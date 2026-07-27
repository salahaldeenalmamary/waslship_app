import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../widgets/elite_top_bar.dart';
import '../widgets/elite_empty_state.dart';

@RoutePage()
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key, this.onShipmentTap});

  final VoidCallback? onShipmentTap;

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _EliteNotification {
  _EliteNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    this.read = false,
  });

  final int id;
  final String type;
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  bool read;
}

class _NotificationsPageState extends State<NotificationsPage> {
  late List<_EliteNotification> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      _EliteNotification(
        id: 1,
        type: 'shipment',
        title: 'شحنتك قيد التوصيل',
        description: 'الشحنة رقم #BL-44821 في طريقها إليك الآن.',
        time: 'منذ 30 دقيقة',
        icon: Icons.inventory_2_outlined,
        iconBg: Colors.blue.withValues(alpha: 0.1),
        iconColor: Colors.blue,
      ),
      _EliteNotification(
        id: 2,
        type: 'promo',
        title: 'خصم 20% على شحنتك القادمة',
        description: 'استخدم الكود ELITE20 عند الدفع للاستفادة من العرض.',
        time: 'منذ ساعتين',
        icon: Icons.local_offer_outlined,
        iconBg: const Color(0xFF00030A).withValues(alpha: 0.08),
        iconColor: const Color(0xFF00030A),
      ),
      _EliteNotification(
        id: 3,
        type: 'shipment',
        title: 'تم تسليم الشحنة',
        description: 'تم تسليم الشحنة رقم #BL-99283 بنجاح.',
        time: 'أمس',
        icon: Icons.check_circle_outline_rounded,
        iconBg: const Color(0xFF10B981).withValues(alpha: 0.1),
        iconColor: const Color(0xFF10B981),
        read: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: EliteTopBar(title: 'الإشعارات', showBack: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // Actions row
            if (_notifications.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الإشعارات',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors.primary,
                    ),
                  ),
                  Row(
                    children: [
                      _ActionChip(
                        label: 'تحديد كمقروء',
                        color: colors.primary,
                        bg: colors.primaryContainer,
                        onTap: () => setState(() {
                          for (final n in _notifications) n.read = true;
                        }),
                      ),
                      const SizedBox(width: 8),
                      _ActionChip(
                        label: 'مسح',
                        color: colors.error,
                        bg: colors.errorContainer,
                        icon: Icons.delete_outline_rounded,
                        onTap: () => setState(() => _notifications.clear()),
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Expanded(
              child: _notifications.isEmpty
                  ? const EliteEmptyState(
                      icon: Icons.notifications_off_outlined,
                      title: 'لا توجد إشعارات',
                      description:
                          'لم يصلك أي إشعار جديد بعد. سنقوم بإعلامك فور وجود أي تحديثات.',
                    )
                  : ListView.separated(
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemCount: _notifications.length,
                      itemBuilder: (context, i) {
                        final n = _notifications[i];
                        return GestureDetector(
                          onTap: () {
                            setState(() => n.read = true);
                            if (n.type == 'shipment')
                              widget.onShipmentTap?.call();
                          },
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: n.read ? 0.7 : 1.0,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: n.read
                                    ? colors.surfaceContainerLow
                                    : colors.surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: n.read
                                      ? colors.outlineVariant.withValues(
                                          alpha: 0.2,
                                        )
                                      : colors.outlineVariant.withValues(
                                          alpha: 0.4,
                                        ),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: n.iconBg,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      n.icon,
                                      color: n.iconColor,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                n.title,
                                                style: textTheme.titleSmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: n.read
                                                          ? colors
                                                                .onSurfaceVariant
                                                          : colors.primary,
                                                    ),
                                              ),
                                            ),
                                            if (!n.read)
                                              Container(
                                                width: 8,
                                                height: 8,
                                                margin: const EdgeInsets.only(
                                                  top: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: colors.primary,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          n.description,
                                          style: textTheme.bodySmall?.copyWith(
                                            color: colors.onSurfaceVariant,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          n.time,
                                          style: textTheme.labelSmall?.copyWith(
                                            color: colors.outline,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.label,
    required this.color,
    required this.bg,
    required this.onTap,
    this.icon,
  });

  final String label;
  final Color color;
  final Color bg;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
