class TreatmentCheckpoint {
  final String title;

  /// action | monitor | evaluation
  final String type;

  /// Actual calendar date
  final DateTime scheduledDate;

  /// Days from treatment start
  final int dayOffset;

  final bool completed;

  const TreatmentCheckpoint({
    required this.title,
    required this.type,
    required this.scheduledDate,
    required this.dayOffset,
    this.completed = false,
  });

  TreatmentCheckpoint copyWith({
    String? title,
    String? type,
    DateTime? scheduledDate,
    int? dayOffset,
    bool? completed,
  }) {
    return TreatmentCheckpoint(
      title: title ?? this.title,
      type: type ?? this.type,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      dayOffset: dayOffset ?? this.dayOffset,
      completed: completed ?? this.completed,
    );
  }
}