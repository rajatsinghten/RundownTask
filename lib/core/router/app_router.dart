import 'package:flutter/material.dart';
import '../../shared/widgets/main_screen.dart';
import '../../features/inbox/screens/inbox_triage_screen.dart';
import '../../features/profile/screens/profile_screen.dart';

class AppRouter {
  AppRouter._();

  static const String main = '/';
  static const String inboxTriage = '/inbox-triage';
  static const String profile = '/profile';

  /// Reusable slide-from-right page route
  static Route<dynamic> _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slideTween = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));

        return SlideTransition(
          position: animation.drive(slideTween),
          child: child,
        );
      },
    );
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case main:
        return _slideRoute(const MainScreen(), settings);
      case inboxTriage:
        final args = settings.arguments as Map<String, dynamic>?;
        return _slideRoute(
          InboxTriageScreen(
            senderInitials: args?['senderInitials'] ?? 'JS',
            senderName: args?['senderName'] ?? 'Jason S.',
            senderEmail: args?['senderEmail'] ?? '<jason@stripe.com>',
            source: args?['source'] ?? 'Gmail',
            time: args?['time'] ?? '10:42 AM',
            subject: args?['subject'] ?? 'API integration requirements for Q4 launch',
            body: args?['body'] ?? '',
          ),
          settings,
        );
      case profile:
        return _slideRoute(const ProfileScreen(), settings);
      default:
        return _slideRoute(
          Scaffold(
            body: Center(
              child: Text('No route defined for \${settings.name}'),
            ),
          ),
          settings,
        );
    }
  }
}
