import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/constants.dart';

class NothingButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final NothingButtonVariant variant;
  final bool isLoading;

  const NothingButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = NothingButtonVariant.primary,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final isDisabled = onPressed == null;

    Color backgroundColor;
    Color textColor;
    Color borderColor;

    switch (variant) {
      case NothingButtonVariant.primary:
        backgroundColor = isDisabled ? colors.textDisabled : colors.textDisplay;
        textColor = colors.background;
        borderColor = Colors.transparent;
        break;
      case NothingButtonVariant.secondary:
        backgroundColor = Colors.transparent;
        textColor = isDisabled ? colors.textDisabled : colors.textPrimary;
        borderColor = colors.borderVisible;
        break;
      case NothingButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        textColor = isDisabled ? colors.textDisabled : colors.textSecondary;
        borderColor = Colors.transparent;
        break;
      case NothingButtonVariant.destructive:
        backgroundColor = Colors.transparent;
        textColor = colors.accent;
        borderColor = colors.accent;
        break;
    }

    return GestureDetector(
      onTap: isLoading || isDisabled ? null : onPressed,
      child: AnimatedContainer(
        duration: AppConstants.animationFast,
        height: AppConstants.minButtonHeight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusPill),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: textColor,
                  ),
                )
              : Text(
                  label.toUpperCase(),
                  style: NothingTypography.button(textColor),
                ),
        ),
      ),
    );
  }
}

enum NothingButtonVariant { primary, secondary, ghost, destructive }
