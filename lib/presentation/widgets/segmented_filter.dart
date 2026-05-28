import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/constants.dart';
import '../../data/database/app_database.dart';

class SegmentedFilter extends StatelessWidget {
  final TaskFilter selected;
  final ValueChanged<TaskFilter> onChanged;

  const SegmentedFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final filters = [
      (TaskFilter.all, 'ALL'),
      (TaskFilter.today, 'TODAY'),
      (TaskFilter.upcoming, 'UPCOMING'),
      (TaskFilter.completed, 'DONE'),
    ];

    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: colors.borderVisible),
        borderRadius: BorderRadius.circular(AppConstants.radiusInput),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: filters.map((filter) {
          final isSelected = filter.$1 == selected;
          return GestureDetector(
            onTap: () => onChanged(filter.$1),
            child: AnimatedContainer(
              duration: AppConstants.animationNormal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isSelected ? colors.textDisplay : Colors.transparent,
                borderRadius: BorderRadius.circular(AppConstants.radiusInput - 4),
              ),
              alignment: Alignment.center,
              child: Text(
                filter.$2,
                style: TextStyle(
                  fontFamily: 'Space Mono',
                  fontSize: 11,
                  letterSpacing: 0.08,
                  color: isSelected ? colors.background : colors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
