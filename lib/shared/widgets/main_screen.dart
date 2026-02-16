import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/inbox/screens/inbox_stream_screen.dart';
import '../../features/calendar/screens/calendar_screen.dart';
import '../../features/chatbot/screens/chatbot_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int _previousIndex = 0;
  // Total non-archived inbox emails (matches the 4 hardcoded emails in InboxStreamScreen)
  final int _inboxCount = 4;

  void _navigateToTab(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _previousIndex = _currentIndex;
      _currentIndex = index;
    });
  }

  Widget _screenForIndex(int index) {
    switch (index) {
      case 0:
        return HomeScreen(
          key: const ValueKey(0),
          onNavigateToTab: _navigateToTab,
          inboxCount: _inboxCount,
        );
      case 1:
        return const InboxStreamScreen(key: ValueKey(1));
      case 2:
        return const CalendarScreen(key: ValueKey(2));
      case 3:
        return const ChatbotScreen(key: ValueKey(3));
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final goingForward = _currentIndex > _previousIndex;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              // Determine direction based on key comparison
              final isIncoming = child.key == ValueKey(_currentIndex);
              final beginOffset = isIncoming
                  ? Offset(goingForward ? 1.0 : -1.0, 0.0)
                  : Offset(goingForward ? -1.0 : 1.0, 0.0);
              return SlideTransition(
                position: Tween<Offset>(
                  begin: beginOffset,
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
            child: _screenForIndex(_currentIndex),
          ),
          // Bottom nav bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: AppColors.slate100,
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.only(
        left: 32,
        right: 32,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(
            icon: Icons.check_circle_outline,
            activeIcon: Icons.check_circle,
            label: 'To Do',
            index: 0,
          ),
          _buildNavItem(
            icon: Icons.inbox_outlined,
            activeIcon: Icons.inbox,
            label: 'Inbox',
            index: 1,
          ),
          _buildNavItem(
            icon: Icons.calendar_today_outlined,
            activeIcon: Icons.calendar_today,
            label: 'Calendar',
            index: 2,
          ),
          _buildNavItem(
            icon: Icons.smart_toy_outlined,
            activeIcon: Icons.smart_toy,
            label: 'Chatbot',
            index: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => _navigateToTab(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.translationValues(
              0,
              isActive ? -2 : 0,
              0,
            ),
            child: Icon(
              isActive ? activeIcon : icon,
              size: 26,
              color: isActive ? AppColors.primary : AppColors.textSlate400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.workSans(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive ? AppColors.primary : AppColors.textSlate400,
            ),
          ),
        ],
      ),
    );
  }
}
