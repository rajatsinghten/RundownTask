import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:http/http.dart' as http;

/// A custom HTTP client that injects the Google Sign-In auth headers
/// into all requests, so `googleapis` can use it automatically.
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
  // Singleton pattern is useful for services
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  /// Starts the Google Sign-In flow and authenticates with Firebase
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? account = await GoogleSignIn.instance.authenticate(
        scopeHint: [gmail.GmailApi.gmailReadonlyScope],
      );

      if (account == null) {
        // The user canceled the sign-in
        return null;
      }

      // Obtain the auth details
      final GoogleSignInAuthentication googleAuth = await account.authentication;

      // To securely sign in with Firebase, we need the ID token. Sometimes the access token is also requested.
      // With google_sign_in 7.0+, access tokens must be obtained via the authorization client.
      final authzClient = account.authorizationClient;
      final authz = await authzClient.authorizationForScopes([]);
      final String? accessToken = authz?.accessToken;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error during Google Sign-In: $e');
      return null;
    }
  }

  /// Signs out of both Google and Firebase
  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }

  /// Returns an authenticated GmailApi client for the current Google Session
  Future<gmail.GmailApi?> getGmailApi() async {
    try {
      final authClient = GoogleSignIn.instance.authorizationClient;
      // Authorize to get the Gmail Scopes
      final authz = await authClient.authorizeScopes([gmail.GmailApi.gmailReadonlyScope]);
      
      final token = authz.accessToken;
      
      final authHeaders = {
        'Authorization': 'Bearer $token',
        'X-Goog-AuthUser': '0',
      };
      
      final client = GoogleAuthClient(authHeaders);
      
      return gmail.GmailApi(client);
    } catch (e) {
       print('Error getting Gmail API scopes: $e');
       return null;
    }
  }
}
