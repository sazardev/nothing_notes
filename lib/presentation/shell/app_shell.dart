import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/constants.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= AppConstants.tabletBreakpoint;

    if (isDesktop) {
      return _buildDesktopShell(context, colors);
    } else {
      return _buildMobileShell(context, colors);
    }
  }

  Widget _buildDesktopShell(BuildContext context, AppColors colors) {
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: child,
            ),
            Container(width: 1, color: colors.border),
            Expanded(
              flex: 1,
              child: _buildSidebar(context, colors),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileShell(BuildContext context, AppColors colors) {
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(child: child),
      floatingActionButton: _buildFAB(context, colors),
      bottomNavigationBar: _buildBottomNav(context, colors),
    );
  }

  Widget _buildFAB(BuildContext context, AppColors colors) {
    return GestureDetector(
      onTap: () => context.push('/add'),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: colors.textDisplay,
          borderRadius: BorderRadius.circular(AppConstants.radiusPill),
        ),
        child: Center(
          child: Text(
            '+',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w300,
              color: colors.background,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, AppColors colors) {
    final currentPath = GoRouterState.of(context).uri.path;
    final isSettingsActive = currentPath == '/settings';

    return Container(
      height: AppConstants.bottomNavHeight,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            label: 'TASKS',
            isActive: !isSettingsActive,
            onTap: () => context.go('/'),
          ),
          _NavItem(
            label: 'SETTINGS',
            isActive: isSettingsActive,
            onTap: () => context.go('/settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, AppColors colors) {
    final currentPath = GoRouterState.of(context).uri.path;
    final isSettingsActive = currentPath == '/settings';

    return Container(
      color: colors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MENU',
                  style: NothingTypography.label(colors.textSecondary),
                ),
                const SizedBox(height: AppConstants.spaceMd),
                _DesktopNavItem(
                  label: 'TASKS',
                  isActive: !isSettingsActive,
                  onTap: () => context.go('/'),
                ),
                const SizedBox(height: AppConstants.spaceSm),
                _DesktopNavItem(
                  label: 'SETTINGS',
                  isActive: isSettingsActive,
                  onTap: () => context.go('/settings'),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(AppConstants.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NOTHING NOTES',
                  style: NothingTypography.caption(colors.textDisabled),
                ),
                const SizedBox(height: AppConstants.spaceXs),
                Text(
                  'V0.1.0',
                  style: NothingTypography.caption(colors.textDisabled),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: NothingTypography.label(
                isActive ? colors.textDisplay : colors.textDisabled,
              ),
            ),
            if (isActive) ...[
              const SizedBox(height: 4),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.textDisplay,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DesktopNavItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _DesktopNavItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppConstants.spaceSm,
          horizontal: AppConstants.spaceMd,
        ),
        decoration: BoxDecoration(
          border: isActive
              ? Border(left: BorderSide(color: colors.textDisplay, width: 2))
              : null,
        ),
        child: Text(
          label,
          style: NothingTypography.button(
            isActive ? colors.textDisplay : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
