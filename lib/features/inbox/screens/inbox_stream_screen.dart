import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';

class InboxStreamScreen extends StatelessWidget {
  const InboxStreamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildSubHeader(),
                      const SizedBox(height: 16),
                      ..._buildEmailCards(context),
                      const SizedBox(height: 24),
                      _buildSyncStatus(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.all_inbox, color: AppColors.primarySoft, size: 26),
              const SizedBox(width: 12),
              Text(
                'Inbox Stream',
                style: GoogleFonts.dmMono(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMain,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '12 unread',
                  style: GoogleFonts.dmMono(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.filter_list,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Priority Inbox',
            style: GoogleFonts.workSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Mark all read',
              style: GoogleFonts.workSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primarySoft,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildEmailCards(BuildContext context) {
    final emails = [
      {
        'source': 'Gmail',
        'time': '10:42 AM',
        'initials': 'JD',
        'subject': 'Project Phoenix Assets',
        'preview':
            'Hey, I\'ve attached the final SVG exports for the new dashboard icons. Let me know if you need the raw Figma files...',
        'senderName': 'John D.',
        'senderEmail': '<john@design.co>',
      },
      {
        'source': 'Outlook',
        'time': '11:15 AM',
        'initials': 'MS',
        'subject': 'Q3 Budget Review',
        'preview':
            'Please review the attached spreadsheet before our sync at 2pm. We need to finalize the server costs...',
        'senderName': 'Maria S.',
        'senderEmail': '<maria@company.com>',
      },
      {
        'source': 'Gmail',
        'time': '1:30 PM',
        'initials': 'GH',
        'subject': 'Sentry Alert: Production',
        'preview':
            'Issue 4421: NullReferenceException in PaymentController.cs. Occurred 15 times in the last hour.',
        'senderName': 'GitHub',
        'senderEmail': '<noreply@github.com>',
      },
      {
        'source': 'Outlook',
        'time': 'Yesterday',
        'initials': 'HR',
        'subject': 'Updated Policy Docs',
        'preview':
            'The remote work policy has been updated for 2024. Please review the changes in the attached PDF...',
        'senderName': 'HR Team',
        'senderEmail': '<hr@company.com>',
      },
    ];

    return emails.map((email) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _buildEmailCard(context, email),
      );
    }).toList();
  }

  Widget _buildEmailCard(BuildContext context, Map<String, String> email) {
    final isGmail = email['source'] == 'Gmail';

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRouter.inboxTriage,
          arguments: {
            'senderInitials': email['initials'],
            'senderName': email['senderName'],
            'senderEmail': email['senderEmail'],
            'source': email['source'],
            'time': email['time'],
            'subject': email['subject'],
            'body': email['preview'],
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: AppColors.gray100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Source + Time + Avatar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isGmail ? AppColors.gmailBg : AppColors.outlookBg,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isGmail
                              ? AppColors.gmailBorder
                              : AppColors.outlookBorder,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.mail_outline,
                            size: 12,
                            color: isGmail
                                ? AppColors.gmailRed
                                : AppColors.outlookBlue,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            email['source']!.toUpperCase(),
                            style: GoogleFonts.workSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: isGmail
                                  ? AppColors.gmailRed
                                  : AppColors.outlookBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      email['time']!,
                      style: GoogleFonts.dmMono(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gray200),
                  ),
                  child: Center(
                    child: Text(
                      email['initials']!,
                      style: GoogleFonts.workSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSlate600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Subject
            Text(
              email['subject']!,
              style: GoogleFonts.dmMono(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textMain,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            // Preview
            Text(
              email['preview']!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.dmMono(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.archive_outlined,
                            size: 18, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          'Archive',
                          style: GoogleFonts.workSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primarySoft.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_outline,
                            size: 18, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          'Taskify',
                          style: GoogleFonts.workSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.refresh, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          'Syncing mail servers...',
          style: GoogleFonts.workSans(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
