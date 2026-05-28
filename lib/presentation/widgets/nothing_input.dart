import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/constants.dart';

class NothingInput extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? errorText;
  final int maxLines;
  final TextInputType keyboardType;
  final bool autofocus;

  const NothingInput({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.errorText,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: NothingTypography.label(colors.textSecondary),
        ),
        const SizedBox(height: AppConstants.spaceXs),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          autofocus: autofocus,
          style: maxLines > 1
              ? NothingTypography.body(colors.textPrimary)
              : NothingTypography.body(colors.textPrimary),
          cursorColor: colors.textDisplay,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: NothingTypography.body(colors.textDisabled),
            filled: false,
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: hasError ? colors.accent : colors.borderVisible,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: hasError ? colors.accent : colors.borderVisible,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: hasError ? colors.accent : colors.textPrimary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: AppConstants.spaceSm,
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: AppConstants.spaceXs),
          Text(
            errorText!,
            style: NothingTypography.caption(colors.accent),
          ),
        ],
      ],
    );
  }
}
