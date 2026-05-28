import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/task_repository.dart';
import '../../domain/models/task.dart' as domain;

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return TaskRepository(db);
});

final taskFilterProvider = StateProvider<TaskFilter>((ref) => TaskFilter.all);

final tasksStreamProvider = StreamProvider<List<domain.Task>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  final filter = ref.watch(taskFilterProvider);
  return repository.watchTasksByFilter(filter);
});

final allTasksCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);
  final tasks = await repository.watchAllTasks().first;
  return tasks.length;
});

final taskByIdProvider = FutureProvider.family<domain.Task?, int>((ref, id) async {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.getTaskById(id);
});

final taskNotifierProvider = StateNotifierProvider<TaskNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskNotifier(repository);
});

class TaskNotifier extends StateNotifier<AsyncValue<void>> {
  final TaskRepository _repository;

  TaskNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> createTask(domain.Task task) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createTask(task);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateTask(domain.Task task) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateTask(task);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteTask(int id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteTask(id);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleCompletion(int id, bool isCompleted) async {
    try {
      await _repository.toggleTaskCompletion(id, isCompleted);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
