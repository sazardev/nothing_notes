import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/constants.dart';
import '../../providers/tasks_provider.dart';
import '../../widgets/task_row.dart';
import '../../widgets/segmented_filter.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final tasksAsync = ref.watch(tasksStreamProvider);
    final selectedFilter = ref.watch(taskFilterProvider);
    final allTasksCount = ref.watch(allTasksCountProvider);

    final isDesktop = MediaQuery.of(context).size.width > AppConstants.tabletBreakpoint;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, colors, allTasksCount, isDesktop),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spaceMd,
                vertical: AppConstants.spaceSm,
              ),
              child: SegmentedFilter(
                selected: selectedFilter,
                onChanged: (filter) {
                  ref.read(taskFilterProvider.notifier).state = filter;
                },
              ),
            ),
            Expanded(
              child: tasksAsync.when(
                data: (tasks) {
                  if (tasks.isEmpty) {
                    return _buildEmptyState(colors);
                  }
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskRow(
                        task: task,
                        onTap: () {
                          if (task.id != null) {
                            context.push('/task/${task.id}');
                          }
                        },
                        onToggleComplete: (isCompleted) {
                          if (task.id != null) {
                            ref
                                .read(taskNotifierProvider.notifier)
                                .toggleCompletion(task.id!, isCompleted);
                          }
                        },
                      );
                    },
                  );
                },
                loading: () => _buildLoading(colors),
                error: (error, _) => _buildError(colors, error.toString()),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isDesktop
          ? null
          : FloatingActionButton(
              onPressed: () => context.push('/add'),
              backgroundColor: colors.textDisplay,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusPill),
              ),
              child: Icon(
                Icons.add,
                color: colors.background,
              ),
            ),
      bottomNavigationBar: isDesktop ? null : _buildBottomNav(context, colors),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppColors colors,
    AsyncValue<int> allTasksCount,
    bool isDesktop,
  ) {
    return Padding(
      padding: EdgeInsets.all(isDesktop ? AppConstants.spaceLg : AppConstants.spaceMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          allTasksCount.when(
            data: (count) => Text(
              count.toString(),
              style: NothingTypography.displayLg(colors.textDisplay),
            ),
            loading: () => Text(
              '-',
              style: NothingTypography.displayLg(colors.textDisplay),
            ),
            error: (_, __) => Text(
              '0',
              style: NothingTypography.displayLg(colors.textDisplay),
            ),
          ),
          const SizedBox(width: AppConstants.spaceSm),
          Text(
            'TASKS',
            style: NothingTypography.label(colors.textSecondary),
          ),
          const Spacer(),
          if (isDesktop) _buildDesktopNav(context, colors),
        ],
      ),
    );
  }

  Widget _buildDesktopNav(BuildContext context, AppColors colors) {
    final currentPath = GoRouterState.of(context).uri.path;
    final isSettings = currentPath == '/settings';

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (isSettings) context.go('/');
          },
          child: Text(
            '[ TASKS ]',
            style: NothingTypography.button(
              isSettings ? colors.textDisplay : colors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: AppConstants.spaceMd),
        GestureDetector(
          onTap: () {
            if (!isSettings) context.push('/settings');
          },
          child: Text(
            'SETTINGS',
            style: NothingTypography.button(
              isSettings ? colors.textSecondary : colors.textDisplay,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context, AppColors colors) {
    final currentPath = GoRouterState.of(context).uri.path;
    final isSettings = currentPath == '/settings';

    return Container(
      height: AppConstants.bottomNavHeight,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(color: colors.border),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            label: 'TASKS',
            isActive: !isSettings,
            onTap: () => context.go('/'),
          ),
          _NavItem(
            label: 'SETTINGS',
            isActive: isSettings,
            onTap: () => context.push('/settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'NO TASKS',
            style: NothingTypography.heading(colors.textSecondary),
          ),
          const SizedBox(height: AppConstants.spaceSm),
          Text(
            'Add a task to get started',
            style: NothingTypography.body(colors.textDisabled),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading(AppColors colors) {
    return Center(
      child: Text(
        '[LOADING...]',
        style: NothingTypography.body(colors.textSecondary),
      ),
    );
  }

  Widget _buildError(AppColors colors, String error) {
    return Center(
      child: Text(
        '[ERROR: $error]',
        style: NothingTypography.body(colors.accent),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: NothingTypography.label(
                isActive ? colors.textDisplay : colors.textDisabled,
              ),
            ),
            if (isActive) ...[
              const SizedBox(height: 4),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.textDisplay,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
