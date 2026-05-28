import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/tasks_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'nothing_notes_db');
  }

  Future<List<Task>> getAllTasks() => select(tasks).get();

  Stream<List<Task>> watchAllTasks() => select(tasks).watch();

  Future<Task?> getTaskById(int id) =>
      (select(tasks)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertTask(TasksCompanion task) => into(tasks).insert(task);

  Future<bool> updateTask(TasksCompanion task) =>
      update(tasks).replace(task);

  Future<int> deleteTask(int id) =>
      (delete(tasks)..where((t) => t.id.equals(id))).go();

  Future<void> toggleTaskCompletion(int id, bool isCompleted) =>
      (update(tasks)..where((t) => t.id.equals(id)))
          .write(TasksCompanion(isCompleted: Value(isCompleted)));

  Stream<List<Task>> watchTasksByFilter(TaskFilter filter) {
    final query = select(tasks);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final nextWeek = today.add(const Duration(days: 7));

    switch (filter) {
      case TaskFilter.all:
        break;
      case TaskFilter.today:
        query.where((t) {
          return t.dueDate.isNotNull() &
              t.dueDate.isBiggerOrEqualValue(today.millisecondsSinceEpoch) &
              t.dueDate.isSmallerThanValue(tomorrow.millisecondsSinceEpoch);
        });
        break;
      case TaskFilter.upcoming:
        query.where((t) {
          return t.dueDate.isNotNull() &
              t.dueDate.isBiggerOrEqualValue(today.millisecondsSinceEpoch) &
              t.dueDate.isSmallerThanValue(nextWeek.millisecondsSinceEpoch);
        });
        break;
      case TaskFilter.completed:
        query.where((t) => t.isCompleted.equals(true));
        break;
    }

    return query.watch();
  }
}

enum TaskFilter { all, today, upcoming, completed }
