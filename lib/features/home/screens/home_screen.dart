import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/models/task_model.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int)? onNavigateToTab;
  final int inboxCount;
  final List<Task> tasks;
  final void Function(String) onToggleTask;
  final void Function(String, String, DateTime) onAddTask;

  const HomeScreen({
    super.key,
    this.onNavigateToTab,
    this.inboxCount = 0,
    required this.tasks,
    required this.onToggleTask,
    required this.onAddTask,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  // Filter tasks for today
  List<Task> get _todayTasks {
    final now = DateTime.now();
    return widget.tasks.where((t) {
      return t.date.year == now.year &&
             t.date.month == now.month &&
             t.date.day == now.day;
    }).toList();
  }

  int get _dueCount => _todayTasks.where((t) => !t.isDone).length;

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
                      if (_titleController.text.trim().isNotEmpty) {
                        widget.onAddTask(
                          _titleController.text.trim(),
                          _timeController.text.trim().isEmpty ? 'No time' : _timeController.text.trim(),
                          DateTime.now(),
                        );
                      }
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Add Task',
                      style: GoogleFonts.workSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
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
                          const SizedBox(height: 8),
                          _buildStatCards(),
                          const SizedBox(height: 24),
                          _buildTimelineHeader(),
                          const SizedBox(height: 12),
                          _buildTimelineList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Floating Add Task button
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

  Widget _buildStatCards() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DUE TODAY',
                  style: GoogleFonts.workSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSlate400,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _dueCount.toString().padLeft(2, '0'),
                  style: GoogleFonts.workSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSlate800,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => widget.onNavigateToTab?.call(1),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'INBOX',
                    style: GoogleFonts.workSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSlate400,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        widget.inboxCount.toString().padLeft(2, '0'),
                        style: GoogleFonts.workSans(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSlate800,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'new',
                        style: GoogleFonts.workSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primarySoft,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'TIMELINE',
            style: GoogleFonts.workSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textSlate400,
              letterSpacing: 2,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              'view_all',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSlate400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineList() {
    final tasks = _todayTasks;
    return Column(
      children: List.generate(
        tasks.length,
        (index) => _buildTaskItem(tasks[index]),
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    final bool isDone = task.isDone;

    return GestureDetector(
      onTap: () => widget.onToggleTask(task.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDone ? AppColors.slate50 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDone ? 0.01 : 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isDone ? AppColors.gray200 : AppColors.gray50,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isDone ? AppColors.primary : AppColors.gray300,
                  width: 2,
                ),
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                task.title,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDone ? AppColors.textSlate300 : AppColors.textSlate800,
                  letterSpacing: -0.3,
                  decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                  decorationColor: AppColors.textSlate300,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              task.timeText,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDone ? AppColors.textSlate300 : AppColors.textSlate400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

