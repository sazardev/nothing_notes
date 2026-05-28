enum Priority {
  low(0),
  medium(1),
  high(2);

  final int value;
  const Priority(this.value);

  static Priority fromValue(int value) {
    return Priority.values.firstWhere(
      (p) => p.value == value,
      orElse: () => Priority.medium,
    );
  }
}

class Task {
  final int? id;
  final String title;
  final String? notes;
  final DateTime? dueDate;
  final Priority priority;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    this.id,
    required this.title,
    this.notes,
    this.dueDate,
    this.priority = Priority.medium,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Task copyWith({
    int? id,
    String? title,
    String? notes,
    DateTime? dueDate,
    Priority? priority,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          notes == other.notes &&
          dueDate == other.dueDate &&
          priority == other.priority &&
          isCompleted == other.isCompleted;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      notes.hashCode ^
      dueDate.hashCode ^
      priority.hashCode ^
      isCompleted.hashCode;
}
