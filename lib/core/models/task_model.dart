

class Task {
  final String id;
  final String title;
  final String timeText;
  final DateTime date;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.timeText,
    required this.date,
    this.isDone = false,
  });

  Task copyWith({
    String? title,
    String? timeText,
    DateTime? date,
    bool? isDone,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      timeText: timeText ?? this.timeText,
      date: date ?? this.date,
      isDone: isDone ?? this.isDone,
    );
  }
}
