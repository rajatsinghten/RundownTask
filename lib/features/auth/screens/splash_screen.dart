import 'package:flutter/material.dart';
import '../../../core/router/app_router.dart';

/// Animated splash screen shown once at app startup.
/// Navigates to login or main after the animation finishes.
/// Uses its own unique route `/splash` — nothing else ever navigates here,
/// so it can never loop.
class SplashScreen extends StatefulWidget {
  final bool isLoggedIn;
  const SplashScreen({super.key, required this.isLoggedIn});

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

    // Navigate once after animation completes + small buffer
    Future.delayed(const Duration(milliseconds: 1500), _navigateAway);
  }

  void _navigateAway() {
    if (!mounted || _navigated) return;
    _navigated = true;
    final route = widget.isLoggedIn ? AppRouter.main : AppRouter.login;
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
