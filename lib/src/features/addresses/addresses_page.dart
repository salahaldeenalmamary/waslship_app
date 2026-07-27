import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../widgets/elite_top_bar.dart';
import '../widgets/elite_empty_state.dart';

/// Elite saved addresses page.
@RoutePage()
class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key, this.onAddNew});

  final VoidCallback? onAddNew;

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _EliteAddressData {
  const _EliteAddressData({
    required this.label,
    required this.address,
    required this.isDefault,
  });

  final String label;
  final String address;
  final bool isDefault;
}

class _AddressesPageState extends State<AddressesPage> {
  final _addresses = [
    const _EliteAddressData(
      label: 'المنزل',
      address: 'الرياض، حي النرجس، شارع الأمير سلطان',
      isDefault: true,
    ),
    const _EliteAddressData(
      label: 'العمل',
      address: 'الرياض، طريق الملك فهد، برج المملكة',
      isDefault: false,
    ),
    const _EliteAddressData(
      label: 'المستودع',
      address: 'الرياض، المنطقة الصناعية، مستودع 14',
      isDefault: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surfaceContainer,
      appBar: EliteTopBar(title: 'العناوين المحفوظة', showBack: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.onAddNew,
        icon: const Icon(Icons.add_location_rounded),
        label: const Text('إضافة عنوان'),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      body: _addresses.isEmpty
          ? const EliteEmptyState(
              icon: Icons.location_off_outlined,
              title: 'لا توجد عناوين',
              description:
                  'لم تقم بحفظ أي عناوين بعد. أضف عنواناً جديداً للبدء.',
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: _addresses.length,
              itemBuilder: (context, i) {
                final addr = _addresses[i];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: addr.isDefault
                          ? colors.primary.withValues(alpha: 0.4)
                          : colors.outlineVariant.withValues(alpha: 0.35),
                      width: addr.isDefault ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: addr.isDefault
                              ? colors.primaryContainer
                              : colors.surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.location_on_rounded,
                          color: addr.isDefault
                              ? colors.primary
                              : colors.onSurfaceVariant,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  addr.label,
                                  style: textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (addr.isDefault) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colors.primaryContainer,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'افتراضي',
                                      style: textTheme.labelSmall?.copyWith(
                                        color: colors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              addr.address,
                              style: textTheme.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.more_vert_rounded,
                          color: colors.onSurfaceVariant,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
