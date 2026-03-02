import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      Navigator.pushReplacementNamed(context, AppRouter.main);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email and password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 64),

                  // ── Logo ────────────────────────────────────────────────
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Rundown',
                            style: GoogleFonts.workSans(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ── Heading ─────────────────────────────────────────────
                  Text(
                    'Login',
                    style: GoogleFonts.workSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Email Field ─────────────────────────────────────────
                  _buildLabel('Email'),
                  const SizedBox(height: 8),
                  _buildInputField(
                    controller: _emailController,
                    hint: 'Enter your email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  // ── Password Field ──────────────────────────────────────
                  _buildLabel('Password'),
                  const SizedBox(height: 8),
                  _buildInputField(
                    controller: _passwordController,
                    hint: '••••••••',
                    icon: Icons.lock_outline,
                    obscureText: !_isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textSlate400,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() => _isPasswordVisible = !_isPasswordVisible);
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Forgot Password – left-aligned
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.workSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Login Button ────────────────────────────────────────
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Login',
                        style: GoogleFonts.workSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── OR Divider ──────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.gray200, thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          'or',
                          style: GoogleFonts.workSans(
                            fontSize: 13,
                            color: AppColors.textSlate400,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: AppColors.gray200, thickness: 1)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Continue with Google ────────────────────────────────
                  _buildSocialButton(
                    onPressed: () async {
                      final credential = await AuthService().signInWithGoogle();
                      if (credential != null) {
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(context, AppRouter.main);
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Google Sign-In failed or was canceled.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    icon: _googleIcon(),
                    label: 'Continue with Gmail',
                  ),

                  const SizedBox(height: 12),

                  // ── Continue with Microsoft ─────────────────────────────
                  _buildSocialButton(
                    onPressed: () async {
                      final token = await AuthService().signInWithMicrosoft();
                      if (token != null) {
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(context, AppRouter.main);
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Microsoft Sign-In failed or was canceled.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    icon: _microsoftIcon(),
                    label: 'Continue with Microsoft',
                  ),

                  const SizedBox(height: 32),

                  // ── Sign Up Link ────────────────────────────────────────
                  Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an account? ",
                              style: GoogleFonts.workSans(
                                fontSize: 14,
                                color: AppColors.textSlate500,
                              ),
                            ),
                            TextSpan(
                              text: 'Signup',
                              style: GoogleFonts.workSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.workSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1A1A1A),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: GoogleFonts.workSans(
          fontSize: 15,
          color: const Color(0xFF1A1A1A),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.workSans(
            fontSize: 15,
            color: AppColors.textSlate400,
          ),
          prefixIcon: Icon(icon, color: AppColors.textSlate400, size: 20),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onPressed,
    required Widget icon,
    required String label,
  }) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          children: [
            icon,
            Expanded(
              child: Center(
                child: Text(
                  label,
                  style: GoogleFonts.workSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _googleIcon() {
    return Image.network(
      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/120px-Google_%22G%22_logo.svg.png',
      height: 22,
      width: 22,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.g_mobiledata, color: Color(0xFFEA4335), size: 26),
    );
  }

  Widget _microsoftIcon() {
    return SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(painter: _MicrosoftLogoPainter()),
    );
  }
}

class _MicrosoftLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gap = size.width * 0.09;
    final sq = (size.width - gap) / 2;
    final colors = [
      const Color(0xFFF25022), // top-left  red
      const Color(0xFF7FBA00), // top-right green
      const Color(0xFF00A4EF), // bottom-left blue
      const Color(0xFFFFB900), // bottom-right yellow
    ];
    final rects = [
      Rect.fromLTWH(0, 0, sq, sq),
      Rect.fromLTWH(sq + gap, 0, sq, sq),
      Rect.fromLTWH(0, sq + gap, sq, sq),
      Rect.fromLTWH(sq + gap, sq + gap, sq, sq),
    ];
    final paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 4; i++) {
      canvas.drawRect(rects[i], paint..color = colors[i]);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

