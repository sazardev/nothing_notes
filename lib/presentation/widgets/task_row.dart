import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/constants.dart';
import '../../domain/models/task.dart';

class TaskRow extends StatefulWidget {
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
  State<TaskRow> createState() => _TaskRowState();
}

class _TaskRowState extends State<TaskRow> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final isOverdue = widget.task.dueDate != null &&
        widget.task.dueDate!.isBefore(DateTime.now()) &&
        !widget.task.isCompleted;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: AppConstants.animationFast,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spaceMd,
          vertical: AppConstants.spaceSm + 4,
        ),
        color: _isPressed ? colors.surface : Colors.transparent,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: colors.border),
          ),
        ),
        child: Row(
          children: [
            _Checkbox(
              isChecked: widget.task.isCompleted,
              onChanged: (value) => widget.onToggleComplete(value ?? false),
            ),
            const SizedBox(width: AppConstants.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.title,
                    style: NothingTypography.body(
                      widget.task.isCompleted
                          ? colors.textDisabled
                          : colors.textPrimary,
                    ).copyWith(
                      decoration: widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.task.notes != null && widget.task.notes!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      widget.task.notes!,
                      style: NothingTypography.caption(colors.textDisabled),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (widget.task.dueDate != null) ...[
              const SizedBox(width: AppConstants.spaceSm),
              Text(
                _formatDate(widget.task.dueDate!),
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

class _Checkbox extends StatefulWidget {
  final bool isChecked;
  final ValueChanged<bool> onChanged;

  const _Checkbox({
    required this.isChecked,
    required this.onChanged,
  });

  @override
  State<_Checkbox> createState() => _CheckboxState();
}

class _CheckboxState extends State<_Checkbox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    await _controller.forward();
    await _controller.reverse();
    widget.onChanged(!widget.isChecked);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: AppConstants.animationNormal,
              width: AppConstants.checkboxSize,
              height: AppConstants.checkboxSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isChecked ? colors.success : Colors.transparent,
                border: Border.all(
                  color: widget.isChecked ? colors.success : colors.borderVisible,
                  width: 2,
                ),
              ),
              child: widget.isChecked
                  ? Center(
                      child: Text(
                        '✓',
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.background,
                          height: 1,
                        ),
                      ),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}