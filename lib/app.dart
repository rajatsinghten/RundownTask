import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

class RundownTaskApp extends StatelessWidget {
  final bool isLoggedIn;

  const RundownTaskApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rundown Task',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRouter.splash,
      onGenerateRoute: (settings) {
        // Inject isLoggedIn into the splash route
        if (settings.name == AppRouter.splash) {
          return AppRouter.generateSplashRoute(isLoggedIn, settings);
        }
        return AppRouter.generateRoute(settings);
      },
    );
  }
}
