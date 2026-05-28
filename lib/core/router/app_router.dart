import 'package:go_router/go_router.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/task_detail/task_detail_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../constants.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: RouteNames.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/task/:id',
      name: RouteNames.taskDetail,
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        return TaskDetailScreen(taskId: id);
      },
    ),
    GoRoute(
      path: '/add',
      name: RouteNames.addTask,
      builder: (context, state) => const TaskDetailScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: RouteNames.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
