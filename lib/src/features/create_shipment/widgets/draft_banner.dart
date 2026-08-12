import '../../../imports/imports.dart';
import '../providers/create_shipment_provider.dart';

class DraftBanner extends ConsumerWidget {
  const DraftBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasDraft = ref.watch(
      createShipmentProvider.select((s) => s.hasExistingDraft),
    );

    if (!hasDraft) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.brandGoldLight,
        border: Border.all(color: context.brandGoldBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.save, size: 18, color: context.brandGold),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'توجد مسودة شحنة محفوظة مسبقاً',
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.onSurfaceColor,
                  ),
                ),
                Text(
                  'هل ترغب بالاستمرار من حيث توقفت؟',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.onSurfaceVariantColor,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () =>
                    ref.read(createShipmentProvider.notifier).restoreDraft(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.brandGold,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  textStyle: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.restore, size: 12),
                    SizedBox(width: 4),
                    Text('استعادة'),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                onPressed: () =>
                    ref.read(createShipmentProvider.notifier).clearDraft(),
                icon: Icon(Icons.delete_outline,
                    size: 14, color: context.outlineColor),
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(6),
                ),
                tooltip: 'حذف المسودة',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
