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

    final isMobile = MediaQuery.of(context).size.width < AppConstants.mobileBreakpoint;
    final horizontalPadding = isMobile ? AppConstants.spaceMd : AppConstants.spaceLg;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, colors, allTasksCount, horizontalPadding),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
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
                        ref.read(taskNotifierProvider.notifier).toggleCompletion(task.id!, isCompleted);
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
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppColors colors,
    AsyncValue<int> allTasksCount,
    double padding,
  ) {
    return Padding(
      padding: EdgeInsets.all(padding),
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
            error: (_, _) => Text(
              '0',
              style: NothingTypography.displayLg(colors.textDisplay),
            ),
          ),
          const SizedBox(width: AppConstants.spaceSm),
          Text(
            'TASKS',
            style: NothingTypography.label(colors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppColors colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.space2xl),
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
