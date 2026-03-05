import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/email_cache_service.dart';

class InboxStreamScreen extends StatefulWidget {
  const InboxStreamScreen({super.key});

  @override
  State<InboxStreamScreen> createState() => _InboxStreamScreenState();
}

class _InboxStreamScreenState extends State<InboxStreamScreen>
    with AutomaticKeepAliveClientMixin {
  List<Map<String, String>> _emails = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _hasFetched = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadEmails();
  }

  /// Load emails from cache first, then fetch fresh from Gmail.
  Future<void> _loadEmails() async {
    // If we already fetched this session, don't re-fetch
    if (_hasFetched) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Try cache first for instant display
    final cached = await EmailCacheService().getCachedEmails();
    if (cached != null && cached.isNotEmpty) {
      setState(() {
        _emails = cached;
        _isLoading = false;
        _hasFetched = true;
      });
      // Still fetch fresh data in the background
      _fetchEmailsSilently();
      return;
    }

    // No cache — fetch from Gmail
    await _fetchEmails();
  }

  /// Fetch from Gmail and update the UI. Called on first load or pull-to-refresh.
  Future<void> _fetchEmails() async {
    setState(() {
      _isLoading = _emails.isEmpty; // Only show spinner if no cached data
      _errorMessage = null;
    });

    try {
      final gmailApi = await AuthService().getGmailApi();

      if (gmailApi == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Gmail not connected. Please sign in with Google first.';
        });
        return;
      }

      final emailData = await _fetchFromGmailApi(gmailApi);

      // Cache the results
      await EmailCacheService().cacheEmails(emailData);

      setState(() {
        _emails = emailData;
        _isLoading = false;
        _hasFetched = true;
      });
    } catch (e) {
      print('Error fetching emails: $e');
      setState(() {
        _isLoading = false;
        if (_emails.isEmpty) {
          _errorMessage = 'Failed to load emails. Please try again.';
        }
      });
    }
  }

  /// Fetch fresh emails in background without showing a loading spinner.
  Future<void> _fetchEmailsSilently() async {
    try {
      final gmailApi = await AuthService().getGmailApi();
      if (gmailApi == null) return;

      final emailData = await _fetchFromGmailApi(gmailApi);
      await EmailCacheService().cacheEmails(emailData);

      if (mounted) {
        setState(() {
          _emails = emailData;
        });
      }
    } catch (e) {
      print('Background email refresh failed: $e');
    }
  }

  /// Core Gmail API fetch logic — returns parsed email data.
  Future<List<Map<String, String>>> _fetchFromGmailApi(gmail.GmailApi gmailApi) async {
    // Fetch messages from last 10 days
    final tenDaysAgo = DateTime.now().subtract(const Duration(days: 10));
    final afterDate = DateFormat('yyyy/MM/dd').format(tenDaysAgo);

    final messageList = await gmailApi.users.messages.list(
      'me',
      maxResults: 20,
      labelIds: ['INBOX'],
      q: 'after:$afterDate',
    );

    final messages = messageList.messages ?? [];
    final List<Map<String, String>> emailData = [];

    for (final msg in messages) {
      try {
        final fullMsg = await gmailApi.users.messages.get(
          'me',
          msg.id!,
          format: 'metadata',
          metadataHeaders: ['From', 'Subject', 'Date'],
        );

        final headers = fullMsg.payload?.headers ?? [];
        String from = '';
        String subject = '';
        String date = '';

        for (final header in headers) {
          switch (header.name?.toLowerCase()) {
            case 'from':
              from = header.value ?? '';
            case 'subject':
              subject = header.value ?? '';
            case 'date':
              date = header.value ?? '';
          }
        }

        final senderName = _parseSenderName(from);
        final senderEmail = _parseSenderEmail(from);
        final initials = _getInitials(senderName);
        final timeStr = _formatTime(date);
        final snippet = fullMsg.snippet ?? '';
        final rawDate = _parseRawDate(date);

        emailData.add({
          'source': 'Gmail',
          'time': timeStr,
          'initials': initials,
          'subject': subject.isNotEmpty ? subject : '(No subject)',
          'preview': snippet,
          'senderName': senderName,
          'senderEmail': '<$senderEmail>',
          'messageId': msg.id ?? '',
          'rawDate': rawDate,
        });
      } catch (e) {
        print('Error fetching message ${msg.id}: $e');
      }
    }

    return emailData;
  }

  /// Parse the raw date header into an ISO string for cache filtering.
  String _parseRawDate(String dateStr) {
    try {
      final date = DateFormat("EEE, d MMM yyyy HH:mm:ss Z").parse(dateStr, true);
      return date.toIso8601String();
    } catch (_) {
      try {
        return DateTime.parse(dateStr).toIso8601String();
      } catch (_) {
        return DateTime.now().toIso8601String();
      }
    }
  }

  /// Parse "John Doe <john@example.com>" → "John Doe"
  String _parseSenderName(String from) {
    if (from.contains('<')) {
      final name = from.substring(0, from.indexOf('<')).trim();
      if (name.startsWith('"') && name.endsWith('"')) {
        return name.substring(1, name.length - 1);
      }
      return name.isNotEmpty ? name : from;
    }
    return from.split('@').first;
  }

  /// Parse "John Doe <john@example.com>" → "john@example.com"
  String _parseSenderEmail(String from) {
    final match = RegExp(r'<(.+?)>').firstMatch(from);
    return match?.group(1) ?? from;
  }

  String _getInitials(String name) {
    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String _formatTime(String dateStr) {
    try {
      final date = DateFormat("EEE, d MMM yyyy HH:mm:ss Z").parse(dateStr, true).toLocal();
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays == 0) {
        return DateFormat('h:mm a').format(date);
      } else if (diff.inDays == 1) {
        return 'Yesterday';
      } else if (diff.inDays < 7) {
        return DateFormat('EEEE').format(date);
      } else {
        return DateFormat('MMM d').format(date);
      }
    } catch (_) {
      try {
        final date = DateTime.parse(dateStr).toLocal();
        return DateFormat('h:mm a').format(date);
      } catch (_) {
        return dateStr.length > 10 ? dateStr.substring(0, 10) : dateStr;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primarySoft,
                      ),
                    )
                  : _errorMessage != null
                      ? _buildErrorState()
                      : _emails.isEmpty
                          ? _buildEmptyState()
                          : RefreshIndicator(
                              onRefresh: _fetchEmails,
                              color: AppColors.primarySoft,
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.textSlate400),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: GoogleFonts.workSans(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _hasFetched = false;
                _loadEmails();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primarySoft,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Retry',
                style: GoogleFonts.workSans(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: AppColors.textSlate400),
            const SizedBox(height: 16),
            Text(
              'Your inbox is empty!',
              style: GoogleFonts.workSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textSlate600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No emails to triage right now.',
              style: GoogleFonts.workSans(
                fontSize: 14,
                color: AppColors.textSecondary,
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
          Row(
            children: [
              Text(
                'RunDown',
                style: GoogleFonts.workSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSlate900,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  _hasFetched = false;
                  _fetchEmails();
                },
                icon: const Icon(
                  Icons.refresh,
                  color: AppColors.textSlate400,
                  size: 26,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.filter_list,
                  color: AppColors.textSlate400,
                  size: 26,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRouter.profile);
                },
                icon: const Icon(
                  Icons.account_circle_outlined,
                  size: 30,
                  color: AppColors.textSlate400,
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
          Text(
            '${_emails.length} emails',
            style: GoogleFonts.workSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primarySoft,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildEmailCards(BuildContext context) {
    return _emails.map((email) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _buildEmailCard(context, email),
      );
    }).toList();
  }

  Widget _buildEmailCard(BuildContext context, Map<String, String> email) {
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
                        color: AppColors.gmailBg,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.gmailBorder),
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
                          const Icon(
                            Icons.mail_outline,
                            size: 12,
                            color: AppColors.gmailRed,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'GMAIL',
                            style: GoogleFonts.workSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: AppColors.gmailRed,
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
        const Icon(Icons.check_circle, size: 14, color: AppColors.primarySoft),
        const SizedBox(width: 8),
        Text(
          'Synced with Gmail',
          style: GoogleFonts.workSans(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
