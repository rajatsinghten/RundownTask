import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/auth_service.dart';

/// Animated splash screen shown once at app startup.
/// Restores the Google session while the animation plays,
/// then navigates to login or main based on auth state.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    // Run session restore + navigation in parallel with the animation
    _initAndNavigate();
  }

  Future<void> _initAndNavigate() async {
    // Fire session restore — this happens while the splash animation plays
    await AuthService().restoreSession();

    // Ensure at least 1.5s of splash visibility
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted || _navigated) return;
    _navigated = true;

    // Check auth state AFTER session restore has completed
    final user = FirebaseAuth.instance.currentUser;
    final route = (user != null) ? AppRouter.main : AppRouter.login;
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.asset(
                'assets/Logo.jpeg',
                width: 110,
                height: 110,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
