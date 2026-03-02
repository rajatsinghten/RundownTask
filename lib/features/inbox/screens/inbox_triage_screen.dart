import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class InboxTriageScreen extends StatelessWidget {
  final String senderInitials;
  final String senderName;
  final String senderEmail;
  final String source;
  final String time;
  final String subject;
  final String body;

  const InboxTriageScreen({
    super.key,
    required this.senderInitials,
    required this.senderName,
    required this.senderEmail,
    required this.source,
    required this.time,
    required this.subject,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Expanded(child: _buildEmailCard()),
                    const SizedBox(height: 24),
                    _buildActionButtons(),
                    const SizedBox(height: 16),
                    _buildProgressIndicator(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.textSlate500),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Text(
            'INBOX TRIAGE',
            style: GoogleFonts.workSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSlate400,
              letterSpacing: 1.5,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz, color: AppColors.textSlate500),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: AppColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sender row
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey.shade100,
                      Colors.grey.shade200,
                    ],
                  ),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    senderInitials,
                    style: GoogleFonts.workSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSlate600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          senderName,
                          style: GoogleFonts.workSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSlate900,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            senderEmail,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.workSans(
                              fontSize: 12,
                              color: AppColors.textSlate400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: source == 'Gmail'
                                ? AppColors.gmailBg
                                : AppColors.outlookBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            source.toUpperCase(),
                            style: GoogleFonts.workSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: source == 'Gmail'
                                  ? AppColors.gmailRed
                                  : AppColors.outlookBlue,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          time,
                          style: GoogleFonts.workSans(
                            fontSize: 11,
                            color: AppColors.textSlate400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Subject
          Text(
            subject,
            style: GoogleFonts.workSans(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textSlate900,
              height: 1.3,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 24),
          // Body
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hey team,',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 14,
                      color: AppColors.textSlate600,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Just wanted to circle back on the API changes we discussed last Tuesday. The new endpoints are live in the sandbox environment.',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 14,
                      color: AppColors.textSlate600,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Could you please review the attached documentation and let me know if the payload structure matches your current implementation? We need to finalize this before the code freeze next Friday.',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 14,
                      color: AppColors.textSlate600,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Code block
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.gray50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.gray100),
                    ),
                    child: Text(
                      'GET /v1/payments/intents\nAuthorization: Bearer sk_test_...',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        color: AppColors.textSlate500,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Let me know if you need any clarification on the webhook events.',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 14,
                      color: AppColors.textSlate600,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Best,\nJason',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 14,
                      color: AppColors.textSlate600,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Archive / Ignore button
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {},
              child: Ink(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.slate200,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.slate100,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.slate200,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.archive_outlined,
                          size: 22,
                          color: AppColors.textSlate500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Archive',
                        style: GoogleFonts.workSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSlate600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        // Taskify / Add to Task button
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {},
              child: Ink(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.check_circle_outline_rounded,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Taskify',
                        style: GoogleFonts.workSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      height: 4,
      width: 64,
      decoration: BoxDecoration(
        color: AppColors.gray200,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 21,
          decoration: BoxDecoration(
            color: AppColors.textSlate400,
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
      ),
    );
  }
}
