import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/constants.dart';

class NothingButton extends StatefulWidget {
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
  State<NothingButton> createState() => _NothingButtonState();
}

class _NothingButtonState extends State<NothingButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final isDisabled = widget.onPressed == null;

    Color backgroundColor;
    Color textColor;
    Color borderColor;

    switch (widget.variant) {
      case NothingButtonVariant.primary:
        backgroundColor = isDisabled ? colors.textDisabled : colors.textDisplay;
        textColor = colors.background;
        borderColor = Colors.transparent;
        break;
      case NothingButtonVariant.secondary:
        backgroundColor = _isPressed ? colors.surfaceRaised : Colors.transparent;
        textColor = isDisabled ? colors.textDisabled : colors.textPrimary;
        borderColor = colors.borderVisible;
        break;
      case NothingButtonVariant.ghost:
        backgroundColor = _isPressed ? colors.surface : Colors.transparent;
        textColor = isDisabled ? colors.textDisabled : colors.textSecondary;
        borderColor = Colors.transparent;
        break;
      case NothingButtonVariant.destructive:
        backgroundColor = _isPressed ? colors.accentSubtle : Colors.transparent;
        textColor = colors.accent;
        borderColor = colors.accent;
        break;
    }

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => setState(() => _isPressed = true),
      onTapUp: isDisabled ? null : (_) => setState(() => _isPressed = false),
      onTapCancel: isDisabled ? null : () => setState(() => _isPressed = false),
      onTap: widget.isLoading || isDisabled ? null : widget.onPressed,
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
          child: widget.isLoading
              ? SegmentedLoadingIndicator(
                  color: textColor,
                  size: 20,
                  segmentCount: 4,
                )
              : Text(
                  widget.label.toUpperCase(),
                  style: NothingTypography.button(textColor),
                ),
        ),
      ),
    );
  }
}

enum NothingButtonVariant { primary, secondary, ghost, destructive }

class SegmentedLoadingIndicator extends StatefulWidget {
  final Color color;
  final int segmentCount;
  final double size;

  const SegmentedLoadingIndicator({
    super.key,
    required this.color,
    this.segmentCount = 8,
    this.size = 32,
  });

  @override
  State<SegmentedLoadingIndicator> createState() => _SegmentedLoadingIndicatorState();
}

class _SegmentedLoadingIndicatorState extends State<SegmentedLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.segmentCount, (index) {
              final progress = (_controller.value * widget.segmentCount - index).clamp(0.0, 1.0);
              return Container(
                width: 3,
                height: widget.size * 0.6,
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: widget.color.withOpacity(0.3 + (progress * 0.7)),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}