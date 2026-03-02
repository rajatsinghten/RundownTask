import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'isBot': true,
      'text': 'Hello! I\'m your RunDown assistant. How can I help you today?',
      'time': '10:02 AM',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Height of bottom nav bar: icon(26) + label + paddings ≈ 80px + system bar
    final bottomNavHeight = 80.0 + MediaQuery.of(context).viewPadding.bottom;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SafeArea(bottom: false, child: _buildHeader()),
          Expanded(child: _buildMessageList()),
          _buildQuickActions(),
          _buildInputBar(),
          SizedBox(height: bottomNavHeight - 32),
        ],
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
              Text(
                'RunDown AI',
                style: GoogleFonts.workSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSlate900,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_horiz,
              color: AppColors.textSlate400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      children: [
        // "Today" badge
        Center(
          child: Container(
            margin: const EdgeInsets.only(bottom: 32),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.slate100,
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Text(
              'TODAY',
              style: GoogleFonts.workSans(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textSlate400,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
        // Messages
        ..._messages.map((msg) => _buildMessage(msg)),
      ],
    );
  }

  Widget _buildMessage(Map<String, dynamic> msg) {
    final isBot = msg['isBot'] as bool;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isBot) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 16,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isBot ? Colors.white : AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isBot ? 4 : 16),
                      bottomRight: Radius.circular(isBot ? 16 : 4),
                    ),
                    border: isBot
                        ? Border.all(color: AppColors.slate100)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isBot ? 0.02 : 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    msg['text'] as String,
                    style: GoogleFonts.workSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isBot
                          ? AppColors.textSlate800
                          : Colors.white,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  msg['time'] as String,
                  style: GoogleFonts.workSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSlate400,
                  ),
                ),
              ],
            ),
          ),
          if (!isBot) ...[
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [':add event', ':delete task', ':sync gmail', ':summary'];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: actions.map((action) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  _messageController.text = action;
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.slate100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    action,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSlate500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: AppColors.slate100),
        ),
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                style: GoogleFonts.workSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSlate800,
                ),
                decoration: InputDecoration(
                  hintText: 'Ask anything...',
                  hintStyle: GoogleFonts.workSans(
                    fontSize: 14,
                    color: AppColors.textSlate400,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                autofocus: false,
                onSubmitted: (text) => _sendMessage(text),
              ),
            ),
            GestureDetector(
              onTap: () => _sendMessage(_messageController.text),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_upward,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        'isBot': false,
        'text': text.trim(),
        'time': '10:03 AM',
      });
      _messageController.clear();
    });
    // Placeholder bot reply
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'isBot': true,
            'text': 'Got it! I\'ll process that for you.',
            'time': '10:03 AM',
          });
        });
      }
    });
  }
}
