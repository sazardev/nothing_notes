import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/task.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/task_detail/task_detail_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/shell/app_shell.dart';
import '../constants.dart';
import 'nothing_page_transitions.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: RouteNames.home,
          pageBuilder: (context, state) => NothingPageTransitions.fade(
            child: const HomeScreen(),
            state: state,
          ),
        ),
        GoRoute(
          path: '/task/:id',
          name: RouteNames.taskDetail,
          pageBuilder: (context, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '');
            return NothingPageTransitions.fade(
              child: TaskDetailScreen(
                taskId: id,
                initialTask: state.extra as Task?,
              ),
              state: state,
            );
          },
        ),
        GoRoute(
          path: '/add',
          name: RouteNames.addTask,
          pageBuilder: (context, state) => NothingPageTransitions.fade(
            child: const TaskDetailScreen(),
            state: state,
          ),
        ),
        GoRoute(
          path: '/settings',
          name: RouteNames.settings,
          pageBuilder: (context, state) => NothingPageTransitions.fade(
            child: const SettingsScreen(),
            state: state,
          ),
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