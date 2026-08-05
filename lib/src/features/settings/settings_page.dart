import 'package:waslship/src/app/providers/auth/auth_providers.dart';
import '../../imports/imports.dart';
import '../widgets/elite_top_bar.dart';

@RoutePage(name: 'SettingsRoute')
class SettingsPage extends HookConsumerWidget {
  const SettingsPage({
    super.key,
    this.onAddresses,
    this.onNotifications,
    this.onLogout,
  });

  final VoidCallback? onAddresses;
  final VoidCallback? onNotifications;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final options = [
      const _SettingsOption(
        id: 'profile',
        label: 'المعلومات الشخصية',
        icon: Icons.person_outline_rounded,
      ),
      const _SettingsOption(
        id: 'locations',
        label: 'العناوين المحفوظة',
        icon: Icons.location_on_outlined,
      ),
      const _SettingsOption(
        id: 'notifications',
        label: 'الإشعارات',
        icon: Icons.notifications_none_rounded,
      ),
      const _SettingsOption(
        id: 'security',
        label: 'الأمان والخصوصية',
        icon: Icons.shield_outlined,
      ),
      const _SettingsOption(
        id: 'language',
        label: 'اللغة',
        icon: Icons.language_rounded,
      ),
      const _SettingsOption(
        id: 'support',
        label: 'الدعم والمساعدة',
        icon: Icons.help_outline_rounded,
      ),
    ];

    return Scaffold(
      backgroundColor: colors.surfaceContainer,
      appBar: const EliteTopBar(title: 'الإعدادات'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Profile Header ─────────────────────────────────────────
            Container(
              width: 96,
              height: 96,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.25),
                  width: 2,
                ),
                color: colors.surfaceContainerLow,
              ),
              child: CircleAvatar(
                backgroundColor: colors.primaryContainer,
                child: Icon(
                  Icons.person_rounded,
                  size: 48,
                  color: colors.primary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'يوسف',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'yousef@example.com',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: colors.primaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.25),
                ),
              ),
              child: Text(
                'العضوية النخبة (Elite)',
                style: textTheme.labelSmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // ── Settings List ──────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colors.outlineVariant.withValues(alpha: 0.35),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: List.generate(options.length, (i) {
                  final opt = options[i];
                  final isLast = i == options.length - 1;
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          if (opt.id == 'locations') onAddresses?.call();
                          if (opt.id == 'notifications')
                            onNotifications?.call();
                        },
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: colors.primaryContainer.withValues(
                              alpha: 0.3,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            opt.icon,
                            size: 20,
                            color: colors.primary,
                          ),
                        ),
                        title: Text(
                          opt.label,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_left_rounded,
                          color: colors.outline,
                        ),
                      ),
                      if (!isLast)
                        Divider(
                          height: 1,
                          indent: 70,
                          color: colors.outlineVariant.withValues(alpha: 0.3),
                        ),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),

            // ── Logout ─────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  ref.read(authNotifierProvider.notifier).logout();
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.errorContainer,
                  foregroundColor: colors.onErrorContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SettingsOption {
  const _SettingsOption({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;
}
