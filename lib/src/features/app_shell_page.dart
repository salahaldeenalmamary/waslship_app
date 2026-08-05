import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../app/routing/app_router.gr.dart';

/// ```
/// AppShellPageRoute (this widget)
///   ├── DashboardRoute   (initial)
///   ├── ShipmentsRoute
///   ├── WalletRoute
///   └── SettingsRoute
/// ```
///
/// Secondary screens (TrackRoute, TopUpRoute, NotificationsRoute…) are pushed
/// on top from within their respective tab pages via context.router.push(…).
@RoutePage()
class AppShellPage extends StatelessWidget {
  const AppShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AutoTabsScaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        routes: [
          HomeRoute(),
          ShipmentsRoute(),
          const WalletRoute(),
          SettingsRoute(),
        ],
        bottomNavigationBuilder: (_, tabsRouter) =>
            _EliteBottomNav(tabsRouter: tabsRouter),
      ),
    );
  }
}

// ── Tab definitions ────────────────────────────────────────────────────────────

typedef _TabDef = ({String label, IconData icon, IconData activeIcon});

const List<_TabDef> _kTabs = [
  (
    label: 'الرئيسية',
    icon: Icons.grid_view_outlined,
    activeIcon: Icons.grid_view_rounded,
  ),
  (
    label: 'الشحنات',
    icon: Icons.local_shipping_outlined,
    activeIcon: Icons.local_shipping_rounded,
  ),
  (
    label: 'المحفظة',
    icon: Icons.account_balance_wallet_outlined,
    activeIcon: Icons.account_balance_wallet_rounded,
  ),
  (
    label: 'الإعدادات',
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings_rounded,
  ),
];

// ── Custom Bottom Navigation Bar ───────────────────────────────────────────────

class _EliteBottomNav extends StatelessWidget {
  const _EliteBottomNav({required this.tabsRouter});

  final TabsRouter tabsRouter;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final activeIndex = tabsRouter.activeIndex;

    return Container(
      height: 80 + MediaQuery.paddingOf(context).bottom,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        child: Row(
          children: List.generate(_kTabs.length, (i) {
            final tab = _kTabs[i];
            final isActive = activeIndex == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => tabsRouter.setActiveIndex(i),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? colors.primaryContainer.withValues(alpha: 0.5)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        isActive ? tab.activeIcon : tab.icon,
                        size: 24,
                        color: isActive
                            ? colors.primary
                            : colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tab.label,
                      style: textTheme.labelSmall?.copyWith(
                        color: isActive
                            ? colors.primary
                            : colors.onSurfaceVariant,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
