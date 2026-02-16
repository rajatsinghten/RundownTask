import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/models/task_model.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  final List<Task> tasks;
  final void Function(String) onToggleTask;
  final void Function(String, String, DateTime) onAddTask;

  const CalendarScreen({
    super.key,
    required this.tasks,
    required this.onToggleTask,
    required this.onAddTask,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _onMonthChanged(int delta) {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + delta, 1);
    });
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  List<Task> get _scheduledTasks {
    return widget.tasks.where((t) => _isSameDay(t.date, _selectedDate)).toList();
  }

  void _showAddTaskSheet() {
    _titleController.clear();
    _timeController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.gray300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'NEW TASK',
                  style: GoogleFonts.workSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSlate400,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _titleController,
                  autofocus: true,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSlate800,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Task title...',
                    hintStyle: GoogleFonts.jetBrainsMono(
                      fontSize: 14,
                      color: AppColors.textSlate300,
                    ),
                    filled: true,
                    fillColor: AppColors.slate50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.gray200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.gray200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _timeController,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSlate600,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g. 3:00 PM',
                    hintStyle: GoogleFonts.jetBrainsMono(
                      fontSize: 13,
                      color: AppColors.textSlate300,
                    ),
                    prefixIcon: const Icon(Icons.schedule, size: 20, color: AppColors.textSlate400),
                    filled: true,
                    fillColor: AppColors.slate50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.gray200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.gray200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_titleController.text.isNotEmpty) {
                        final timeText = _timeController.text.isEmpty ? 'All Day' : _timeController.text;
                        widget.onAddTask(_titleController.text, timeText, _selectedDate);
                        Navigator.pop(ctx);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'CREATE TASK',
                      style: GoogleFonts.workSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
                          _buildCalendarMonthHeader(),
                          const SizedBox(height: 16),
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
            // Floating Add Task button (Matched with HomeScreen)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 90,
              right: 24,
              child: GestureDetector(
                onTap: _showAddTaskSheet,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 28,
                    color: Colors.white,
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
    );
  }

  Widget _buildCalendarMonthHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('MMMM yyyy').format(_focusedMonth),
              style: GoogleFonts.workSans(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textSlate900,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => _onMonthChanged(-1),
              icon: const Icon(Icons.chevron_left, color: AppColors.textSlate400),
            ),
            IconButton(
              onPressed: () => _onMonthChanged(1),
              icon: const Icon(Icons.chevron_right, color: AppColors.textSlate400),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    
    // Calculate days
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    
    // weekday is 1-7 (Mon-Sun)
    // We want to align Mon at index 0.
    final firstWeekday = firstDayOfMonth.weekday; // 1 (Mon) to 7 (Sun)
    final leadingPadding = firstWeekday - 1;
    
    final daysInMonth = lastDayOfMonth.day;
    final lastDayOfPrevMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 0).day;

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
          leadingPadding,
          lastDayOfPrevMonth,
          daysInMonth,
        ),
      ],
    );
  }

  List<Widget> _buildCalendarRows(int leadingPadding, int lastDayOfPrevMonth, int daysInMonth) {
    final rows = <Widget>[];
    final allCells = <Widget>[];

    // Previous month days
    for (var i = leadingPadding - 1; i >= 0; i--) {
      allCells.add(_buildDayCell(
        lastDayOfPrevMonth - i,
        isDimmed: true,
      ));
    }

    // Current month days
    for (var i = 1; i <= daysInMonth; i++) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, i);
      final hasTasks = widget.tasks.any((t) => _isSameDay(t.date, date));
      allCells.add(_buildDayCell(
        i,
        isSelected: _isSameDay(date, _selectedDate),
        hasDot: hasTasks,
        onTap: () => _onDaySelected(date),
      ));
    }

    // Next month days to fill grid
    final remainingCells = 42 - allCells.length; // 6 rows of 7
    for (var i = 1; i <= remainingCells; i++) {
      allCells.add(_buildDayCell(
        i,
        isDimmed: true,
      ));
    }

    // Split into rows of 7
    for (var i = 0; i < allCells.length; i += 7) {
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: allCells.sublist(i, i + 7).map((cell) => Expanded(child: cell)).toList(),
          ),
        ),
      );
    }

    return rows;
  }

  Widget _buildDayCell(
    int day, {
    bool isDimmed = false,
    bool isSelected = false,
    bool hasDot = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
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
                  color: isDimmed
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
            if (!hasDot && !isSelected)
              const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduledHeader() {
    final count = _scheduledTasks.length;
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
            '$count task${count == 1 ? '' : 's'}',
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
    final tasks = _scheduledTasks;
    if (tasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Icon(Icons.calendar_today_outlined, size: 48, color: AppColors.slate200),
              const SizedBox(height: 16),
              Text(
                'No tasks scheduled for this day',
                style: GoogleFonts.workSans(
                  fontSize: 14,
                  color: AppColors.textSlate400,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      children: tasks.map((task) => _buildTaskItem(task)).toList(),
    );
  }

  Widget _buildTaskItem(Task task) {
    final isDone = task.isDone;

    return GestureDetector(
      onTap: () => widget.onToggleTask(task.id),
      child: Container(
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
                      task.title,
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
                        const Icon(
                          Icons.schedule,
                          size: 14,
                          color: AppColors.textSlate400,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          task.timeText,
                          style: GoogleFonts.workSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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
        ),
      ),
    );
  }
}

