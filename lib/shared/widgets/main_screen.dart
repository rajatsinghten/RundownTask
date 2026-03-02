import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/inbox/screens/inbox_stream_screen.dart';
import '../../features/calendar/screens/calendar_screen.dart';
import '../../features/chatbot/screens/chatbot_screen.dart';
import '../../core/models/task_model.dart';

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

  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Review Pull Request #402',
      timeText: '10:00 AM',
      date: DateTime.now(),
    ),
    Task(
      id: '2',
      title: 'Deploy Staging Build',
      timeText: '11:30 AM',
      date: DateTime.now(),
    ),
    Task(
      id: '3',
      title: 'Client Sync Notes',
      timeText: '2:00 PM',
      date: DateTime.now(),
    ),
    Task(
      id: '4',
      title: 'Update Security Policy',
      timeText: '4:45 PM',
      date: DateTime.now(),
    ),
    Task(
      id: '5',
      title: 'Team Retrospective',
      timeText: '5:30 PM',
      date: DateTime.now(),
    ),
  ];

  void _navigateToTab(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _previousIndex = _currentIndex;
      _currentIndex = index;
    });
  }

  void _toggleTask(String id) {
    setState(() {
      final taskIndex = _tasks.indexWhere((t) => t.id == id);
      if (taskIndex != -1) {
        _tasks[taskIndex].isDone = !_tasks[taskIndex].isDone;
      }
    });
  }

  void _addTask(String title, String timeText, DateTime date) {
    setState(() {
      _tasks.add(Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        timeText: timeText,
        date: date,
      ));
    });
  }

  Widget _screenForIndex(int index) {
    switch (index) {
      case 0:
        return HomeScreen(
          key: const ValueKey(0),
          onNavigateToTab: _navigateToTab,
          inboxCount: _inboxCount,
          tasks: _tasks,
          onToggleTask: _toggleTask,
          onAddTask: _addTask,
        );
      case 1:
        return const InboxStreamScreen(key: ValueKey(1));
      case 2:
        return CalendarScreen(
          key: const ValueKey(2),
          tasks: _tasks,
          onToggleTask: _toggleTask,
          onAddTask: _addTask,
        );
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
      body: AnimatedSwitcher(
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
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    return ColoredBox(
      // Fill the system nav bar area on Android with white to eliminate black bar
      color: Colors.white,
      child: Container(
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
          // Add enough bottom padding to cover system nav bar on all Android devices
          bottom: (bottomPadding > 0 ? bottomPadding : 16) + 16,
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
              icon: Icons.chat_bubble_outline_rounded,
              activeIcon: Icons.chat_bubble_rounded,
              label: 'Chatbot',
              index: 3,
            ),
          ],
        ),
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
