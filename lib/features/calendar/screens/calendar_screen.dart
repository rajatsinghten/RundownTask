import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 120),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCalendarGrid(),
                          const SizedBox(height: 32),
                          _buildScheduledHeader(),
                          const SizedBox(height: 16),
                          _buildScheduledTasks(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // FAB
            Positioned(
              bottom: 100,
              right: 24,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.blue500,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blue500.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'October 2023',
                style: GoogleFonts.workSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSlate900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'WEEK 42',
                style: GoogleFonts.workSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          // Profile avatar
          Stack(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.slate200,
                  border: Border.all(color: AppColors.slate200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person,
                  size: 24,
                  color: AppColors.textSlate400,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.red500,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.background,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    // Previous month trailing days (25-30)
    final prevMonthDays = [25, 26, 27, 28, 29, 30];
    // Current month days 1-31
    final currentMonthDays = List.generate(31, (i) => i + 1);
    // Dates with dot indicators
    final dottedDays = {3, 10, 20, 25};
    const selectedDay = 18;

    return Column(
      children: [
        // Day labels
        Row(
          children: dayLabels.map((label) {
            return Expanded(
              child: Center(
                child: Text(
                  label,
                  style: GoogleFonts.workSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSlate400,
                    letterSpacing: 1,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        // Calendar grid
        ..._buildCalendarRows(
          prevMonthDays,
          currentMonthDays,
          dottedDays,
          selectedDay,
        ),
      ],
    );
  }

  List<Widget> _buildCalendarRows(
    List<int> prevMonthDays,
    List<int> currentMonthDays,
    Set<int> dottedDays,
    int selectedDay,
  ) {
    final rows = <Widget>[];
    // Each row has 7 cells
    // Row 1: 25, 26, 27, 28, 29, 30 (prev month) + 1
    // Row 2: 2-8
    // Row 3: 9-15
    // Row 4: 16-22
    // Row 5: 23-29
    // Row 6: 30-31

    // Build all cells in order
    final allCells = <Widget>[];

    // Previous month days
    for (final day in prevMonthDays) {
      allCells.add(_buildDayCell(day, isPrevMonth: true));
    }

    // Current month days
    for (final day in currentMonthDays) {
      allCells.add(_buildDayCell(
        day,
        isSelected: day == selectedDay,
        hasDot: dottedDays.contains(day),
      ));
    }

    // Build rows of 7
    for (var i = 0; i < allCells.length; i += 7) {
      final end = (i + 7 > allCells.length) ? allCells.length : i + 7;
      final rowCells = allCells.sublist(i, end);
      // Pad remaining cells
      while (rowCells.length < 7) {
        rowCells.add(const SizedBox(height: 40));
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: rowCells.map((cell) => Expanded(child: cell)).toList(),
          ),
        ),
      );
    }

    return rows;
  }

  Widget _buildDayCell(
    int day, {
    bool isPrevMonth = false,
    bool isSelected = false,
    bool hasDot = false,
  }) {
    return SizedBox(
      height: 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isSelected)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.blue500,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blue200,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$day',
                  style: GoogleFonts.workSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          else
            Text(
              '$day',
              style: GoogleFonts.workSans(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isPrevMonth
                    ? AppColors.textSlate300
                    : AppColors.textSlate600,
              ),
            ),
          if (hasDot && !isSelected)
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScheduledHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Scheduled',
          style: GoogleFonts.workSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textSlate800,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(color: AppColors.slate200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
              ),
            ],
          ),
          child: Text(
            '3 tasks',
            style: GoogleFonts.workSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSlate500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduledTasks() {
    final tasks = [
      {
        'title': 'Deploy backend to Staging',
        'time': 'Today, 10:00 AM',
        'isPrimary': true,
        'done': false,
      },
      {
        'title': 'Team Sync & Standup',
        'time': 'Today, 11:30 AM',
        'isPrimary': false,
        'done': false,
      },
      {
        'title': 'Review PR #402 (Auth Module)',
        'time': 'Today, 02:00 PM',
        'isPrimary': false,
        'done': false,
      },
      {
        'title': 'Morning Coffee',
        'time': 'Today, 08:00 AM',
        'isPrimary': false,
        'done': true,
      },
    ];

    return Column(
      children: tasks.map((task) => _buildTaskItem(task)).toList(),
    );
  }

  Widget _buildTaskItem(Map<String, dynamic> task) {
    final isDone = task['done'] as bool;
    final isPrimary = task['isPrimary'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDone ? AppColors.slate50 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.slate100),
        boxShadow: isDone
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Opacity(
        opacity: isDone ? 0.7 : 1.0,
        child: Row(
          children: [
            // Checkbox
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isDone ? AppColors.primary : AppColors.textSlate300,
                ),
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task['title'] as String,
                    style: GoogleFonts.workSans(
                      fontSize: 14,
                      fontWeight: isDone ? FontWeight.w500 : FontWeight.w600,
                      color: isDone
                          ? AppColors.textSlate500
                          : AppColors.textSlate800,
                      decoration:
                          isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 14,
                        color: isPrimary && !isDone
                            ? AppColors.primary
                            : AppColors.textSlate400,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        task['time'] as String,
                        style: GoogleFonts.workSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isPrimary && !isDone
                              ? AppColors.primary
                              : AppColors.textSlate400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
