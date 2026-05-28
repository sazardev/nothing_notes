import 'package:drift/drift.dart';
import '../../domain/models/task.dart' as domain;
import '../database/app_database.dart';

class TaskRepository {
  final AppDatabase _db;

  TaskRepository(this._db);

  Stream<List<domain.Task>> watchAllTasks() {
    return _db.watchAllTasks().map((tasks) => tasks.map(_mapToDomain).toList());
  }

  Stream<List<domain.Task>> watchTasksByFilter(TaskFilter filter) {
    return _db.watchTasksByFilter(filter).map((tasks) => tasks.map(_mapToDomain).toList());
  }

  Future<domain.Task?> getTaskById(int id) async {
    final task = await _db.getTaskById(id);
    return task != null ? _mapToDomain(task) : null;
  }

  Future<int> createTask(domain.Task task) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return _db.insertTask(TasksCompanion(
      title: Value(task.title),
      notes: Value(task.notes),
      dueDate: Value(task.dueDate?.millisecondsSinceEpoch),
      priority: Value(task.priority.value),
      isCompleted: Value(task.isCompleted),
      createdAt: Value(now),
      updatedAt: Value(now),
    ));
  }

  Future<bool> updateTask(domain.Task task) {
    if (task.id == null) return Future.value(false);
    return _db.updateTask(TasksCompanion(
      id: Value(task.id!),
      title: Value(task.title),
      notes: Value(task.notes),
      dueDate: Value(task.dueDate?.millisecondsSinceEpoch),
      priority: Value(task.priority.value),
      isCompleted: Value(task.isCompleted),
      createdAt: Value(task.createdAt.millisecondsSinceEpoch),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
    ));
  }

  Future<int> deleteTask(int id) {
    return _db.deleteTask(id);
  }

  Future<void> toggleTaskCompletion(int id, bool isCompleted) {
    return _db.toggleTaskCompletion(id, isCompleted);
  }

  domain.Task _mapToDomain(Task task) {
    return domain.Task(
      id: task.id,
      title: task.title,
      notes: task.notes,
      dueDate: task.dueDate != null
          ? DateTime.fromMillisecondsSinceEpoch(task.dueDate!)
          : null,
      priority: domain.Priority.fromValue(task.priority),
      isCompleted: task.isCompleted,
      createdAt: DateTime.fromMillisecondsSinceEpoch(task.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(task.updatedAt),
    );
  }
}
