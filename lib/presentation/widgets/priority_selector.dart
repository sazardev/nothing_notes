import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/constants.dart';
import '../../domain/models/task.dart';

class PrioritySelector extends StatelessWidget {
  final Priority selected;
  final ValueChanged<Priority> onChanged;

  const PrioritySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final priorities = [
      (Priority.low, 'LOW'),
      (Priority.medium, 'MEDIUM'),
      (Priority.high, 'HIGH'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PRIORITY',
          style: TextStyle(
            fontFamily: 'Space Mono',
            fontSize: 11,
            letterSpacing: 0.08,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: AppConstants.spaceSm),
        Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: colors.borderVisible),
            borderRadius: BorderRadius.circular(AppConstants.radiusInput),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: priorities.map((p) {
              final isSelected = p.$1 == selected;
              Color textColor;
              if (p.$1 == Priority.high) {
                textColor = isSelected ? colors.background : colors.accent;
              } else {
                textColor = isSelected ? colors.background : colors.textSecondary;
              }

              return GestureDetector(
                onTap: () => onChanged(p.$1),
                child: AnimatedContainer(
                  duration: AppConstants.animationNormal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? colors.textDisplay : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppConstants.radiusInput - 4),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    p.$2,
                    style: TextStyle(
                      fontFamily: 'Space Mono',
                      fontSize: 11,
                      letterSpacing: 0.08,
                      color: textColor,
                      fontWeight: p.$1 == selected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
