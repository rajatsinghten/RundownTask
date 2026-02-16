import 'package:flutter/material.dart';
import '../../shared/widgets/main_screen.dart';
import '../../features/inbox/screens/inbox_triage_screen.dart';

class AppRouter {
  AppRouter._();

  static const String main = '/';
  static const String inboxTriage = '/inbox-triage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case main:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
        );
      case inboxTriage:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => InboxTriageScreen(
            senderInitials: args?['senderInitials'] ?? 'JS',
            senderName: args?['senderName'] ?? 'Jason S.',
            senderEmail: args?['senderEmail'] ?? '<jason@stripe.com>',
            source: args?['source'] ?? 'Gmail',
            time: args?['time'] ?? '10:42 AM',
            subject: args?['subject'] ?? 'API integration requirements for Q4 launch',
            body: args?['body'] ?? '',
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for \${settings.name}'),
            ),
          ),
        );
    }
  }
}
