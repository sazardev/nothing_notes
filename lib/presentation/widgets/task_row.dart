import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/constants.dart';
import '../../domain/models/task.dart';

class TaskRow extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggleComplete;

  const TaskRow({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final isOverdue = task.dueDate != null &&
        task.dueDate!.isBefore(DateTime.now()) &&
        !task.isCompleted;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spaceMd,
          vertical: AppConstants.spaceSm + 4,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: colors.border),
          ),
        ),
        child: Row(
          children: [
            _Checkbox(
              isChecked: task.isCompleted,
              onChanged: (value) => onToggleComplete(value ?? false),
            ),
            const SizedBox(width: AppConstants.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: NothingTypography.body(
                      task.isCompleted
                          ? colors.textDisabled
                          : colors.textPrimary,
                    ).copyWith(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (task.notes != null && task.notes!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      task.notes!,
                      style: NothingTypography.caption(colors.textDisabled),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (task.dueDate != null) ...[
              const SizedBox(width: AppConstants.spaceSm),
              Text(
                _formatDate(task.dueDate!),
                style: NothingTypography.caption(
                  isOverdue ? colors.accent : colors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) return 'TODAY';
    if (dateOnly == tomorrow) return 'TOM';
    return '${date.month}/${date.day}';
  }
}

class _Checkbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool> onChanged;

  const _Checkbox({
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return GestureDetector(
      onTap: () => onChanged(!isChecked),
      child: AnimatedContainer(
        duration: AppConstants.animationNormal,
        width: AppConstants.checkboxSize,
        height: AppConstants.checkboxSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isChecked ? colors.success : Colors.transparent,
          border: Border.all(
            color: isChecked ? colors.success : colors.borderVisible,
            width: 2,
          ),
        ),
        child: isChecked
            ? Icon(
                Icons.check,
                size: 14,
                color: colors.background,
              )
            : null,
      ),
    );
  }
}
