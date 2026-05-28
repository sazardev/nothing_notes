import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/constants.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    final isDesktop = MediaQuery.of(context).size.width > AppConstants.tabletBreakpoint;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.spaceMd),
              child: Row(
                children: [
                  if (!isDesktop)
                    _BackButton(onTap: () => context.pop()),
                  const SizedBox(width: AppConstants.spaceMd),
                  Text(
                    'SETTINGS',
                    style: NothingTypography.heading(colors.textDisplay),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.spaceMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(title: 'APPEARANCE'),
                    const SizedBox(height: AppConstants.spaceSm),
                    _ThemeToggle(
                      isDark: isDark,
                      onChanged: (dark) {
                        ref.read(themeModeProvider.notifier).setTheme(
                              dark ? ThemeMode.dark : ThemeMode.light,
                            );
                      },
                    ),
                    const SizedBox(height: AppConstants.space2xl),
                    _SectionTitle(title: 'ABOUT'),
                    const SizedBox(height: AppConstants.spaceMd),
                    _InfoRow(label: 'APP NAME', value: 'Nothing Notes'),
                    const SizedBox(height: AppConstants.spaceSm),
                    _InfoRow(label: 'VERSION', value: '0.1.0'),
                    const SizedBox(height: AppConstants.spaceSm),
                    _InfoRow(label: 'DESIGN', value: 'Nothing Design'),
                    const SizedBox(height: AppConstants.space2xl),
                    _InfoRow(
                      label: 'STORAGE',
                      value: 'Local SQLite',
                    ),
                    const SizedBox(height: AppConstants.space2xl),
                    Text(
                      'All data is stored locally on your device. No internet connection required.',
                      style: NothingTypography.caption(colors.textDisabled),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppConstants.backButtonSize,
        height: AppConstants.backButtonSize,
        decoration: BoxDecoration(
          color: colors.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.chevron_left,
          color: colors.textPrimary,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Text(
      title,
      style: NothingTypography.label(colors.textSecondary),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const _ThemeToggle({
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: colors.borderVisible),
        borderRadius: BorderRadius.circular(AppConstants.radiusInput),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleOption(
            label: 'DARK',
            isSelected: isDark,
            onTap: () => onChanged(true),
          ),
          _ToggleOption(
            label: 'LIGHT',
            isSelected: !isDark,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animationNormal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? colors.textDisplay : Colors.transparent,
          borderRadius: BorderRadius.circular(AppConstants.radiusInput - 4),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Space Mono',
            fontSize: 11,
            letterSpacing: 0.08,
            color: isSelected ? colors.background : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: NothingTypography.label(colors.textSecondary),
        ),
        Text(
          value,
          style: NothingTypography.body(colors.textPrimary),
        ),
      ],
    );
  }
}
