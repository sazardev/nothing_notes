import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/task_detail/task_detail_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/shell/app_shell.dart';
import '../constants.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: RouteNames.home,
          builder: (_, _) => const HomeScreen(),
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
          builder: (_, _) => const TaskDetailScreen(),
        ),
        GoRoute(
          path: '/settings',
          name: RouteNames.settings,
          builder: (_, _) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);

class AppResponsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < AppConstants.mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppConstants.mobileBreakpoint &&
      MediaQuery.of(context).size.width < AppConstants.tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppConstants.tabletBreakpoint;

  static double safePadding(BuildContext context, AxisDirection direction) {
    final media = MediaQuery.of(context);
    switch (direction) {
      case AxisDirection.left:
        return media.padding.left;
      case AxisDirection.right:
        return media.padding.right;
      case AxisDirection.up:
        return media.padding.top;
      case AxisDirection.down:
        return media.padding.bottom;
    }
  }
}