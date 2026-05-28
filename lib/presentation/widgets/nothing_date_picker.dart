import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/constants.dart';

class NothingDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onChanged;
  final String label;

  const NothingDatePicker({
    super.key,
    this.selectedDate,
    required this.onChanged,
    this.label = 'DUE DATE',
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final displayText = selectedDate != null
        ? _formatDate(selectedDate!)
        : 'NOT SET';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontFamily: 'Space Mono',
            fontSize: 11,
            letterSpacing: 0.08,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: AppConstants.spaceSm),
        Row(
          children: [
            _ArrowButton(
              icon: Icons.chevron_left,
              onTap: selectedDate != null
                  ? () => _adjustDate(-1)
                  : null,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _showDatePicker(context),
                child: Container(
                  height: AppConstants.minButtonHeight,
                  decoration: BoxDecoration(
                    border: Border.all(color: colors.borderVisible),
                    borderRadius: BorderRadius.circular(AppConstants.radiusInput),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    displayText,
                    style: TextStyle(
                      fontFamily: 'Space Mono',
                      fontSize: 13,
                      letterSpacing: 0.06,
                      color: selectedDate != null
                          ? colors.textPrimary
                          : colors.textDisabled,
                    ),
                  ),
                ),
              ),
            ),
            _ArrowButton(
              icon: Icons.chevron_right,
              onTap: selectedDate != null
                  ? () => _adjustDate(1)
                  : null,
            ),
          ],
        ),
        if (selectedDate != null) ...[
          const SizedBox(height: AppConstants.spaceSm),
          GestureDetector(
            onTap: () => onChanged(null),
            child: Text(
              'CLEAR',
              style: TextStyle(
                fontFamily: 'Space Mono',
                fontSize: 11,
                letterSpacing: 0.08,
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _adjustDate(int days) {
    if (selectedDate == null) return;
    onChanged(selectedDate!.add(Duration(days: days)));
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        final colors = Theme.of(context).brightness == Brightness.dark
            ? AppColors.dark
            : AppColors.light;
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              surface: colors.surface,
              primary: colors.textDisplay,
              onSurface: colors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onChanged(picked);
    }
  }

  String _formatDate(DateTime date) {
    final months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
                    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _ArrowButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppConstants.minButtonHeight,
        height: AppConstants.minButtonHeight,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 20,
          color: onTap != null ? colors.textSecondary : colors.textDisabled,
        ),
      ),
    );
  }
}
