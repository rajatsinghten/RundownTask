import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:http/http.dart' as http;

/// A custom HTTP client that injects auth headers into all requests,
/// so `googleapis` can use it automatically.
class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

class AuthService {
  // Singleton
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  /// Lazily access FirebaseAuth to avoid accessing it before Firebase.initializeApp()
  FirebaseAuth get _auth => FirebaseAuth.instance;

  /// List of scopes required by the application
  static const List<String> scopes = <String>[
    'email',
    gmail.GmailApi.gmailReadonlyScope,
  ];

  /// The currently authenticated Google account (after sign-in).
  GoogleSignInAccount? _googleUser;

  User? get currentUser => _auth.currentUser;
  GoogleSignInAccount? get googleUser => _googleUser;

  /// Initialize the GoogleSignIn singleton. Call this once at app startup.
  Future<void> initializeGoogleSignIn() async {
    try {
      // The serverClientId is the Web client ID from Firebase/Google Cloud Console.
      // It's required to get the idToken for Firebase Auth on Android.
      await GoogleSignIn.instance.initialize(
        serverClientId: '741222572973-amfv89qim6eo8i3lk4hb78ngr48eu76n.apps.googleusercontent.com',
      );
      // Listen for authentication events to keep _googleUser in sync
      GoogleSignIn.instance.authenticationEvents.listen((event) {
        switch (event) {
          case GoogleSignInAuthenticationEventSignIn():
            _googleUser = event.user;
          case GoogleSignInAuthenticationEventSignOut():
            _googleUser = null;
        }
      });
      // Removed attemptLightweightAuthentication() so it doesn't auto-prompt 
      // the user immediately on startup.
    } catch (e) {
      print('GoogleSignIn initialization warning: $e');
    }
  }

  /// Starts the Google Sign-In flow and authenticates with Firebase.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the interactive authentication flow
      final GoogleSignInAccount? account =
          await GoogleSignIn.instance.authenticate();

      if (account == null) {
        // The user canceled the sign-in
        return null;
      }

      _googleUser = account;

      // Get the ID token for Firebase auth
      final GoogleSignInAuthentication googleAuth =
          await account.authentication;

      // Get access token via authorization for Firebase credential
      // Note: We MUST pass non-empty scopes here to avoid IllegalArgumentException on Android
      final GoogleSignInClientAuthorization? authz = await account
          .authorizationClient
          .authorizationForScopes(scopes);
      final String? accessToken = authz?.accessToken;

      // Create a Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error during Google Sign-In: $e');
      rethrow; // Rethrow so the UI can show the exact error
    }
  }

  /// Signs out of Google and Firebase.
  Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.disconnect();
    } catch (_) {}
    await _auth.signOut();
    _googleUser = null;
  }

  /// Returns an authenticated GmailApi client for the current Google session.
  /// Will request Gmail read-only scope if not already granted.
  Future<gmail.GmailApi?> getGmailApi() async {
    try {
      final user = _googleUser;
      if (user == null) return null;

      final scopes = [gmail.GmailApi.gmailReadonlyScope];

      // Try to get existing authorization first
      Map<String, String>? headers = await user
          .authorizationClient
          .authorizationHeaders(scopes);

      // If no existing authorization, request the scopes
      if (headers == null) {
        await user.authorizationClient.authorizeScopes(scopes);
        headers = await user.authorizationClient.authorizationHeaders(scopes);
      }

      if (headers == null) return null;

      final client = GoogleAuthClient(headers);
      return gmail.GmailApi(client);
    } catch (e) {
      print('Error getting Gmail API: $e');
      return null;
    }
  }
}
