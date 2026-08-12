import '../../../imports/imports.dart';
import '../providers/create_shipment_provider.dart';

class StepProgressIndicator extends ConsumerWidget {
  const StepProgressIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createShipmentProvider);
    final step = state.currentStep;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'الخطوة $step من 3',
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.brandGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  step == 1
                      ? 'بيانات الشحنة والمالية'
                      : step == 2
                          ? 'اختيار شركة الشحن'
                          : 'مراجعة وتأكيد',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.onSurfaceVariantColor,
                  ),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () =>
                  ref.read(createShipmentProvider.notifier).saveDraft(),
              icon:
                  Icon(Icons.save_outlined, size: 14, color: context.brandGold),
              label: Text(
                'حفظ كمسودة',
                style: context.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.brandGold,
                ),
              ),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: context.outlineVariantColor),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: context.brandGold,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: step >= 2
                      ? context.brandGold
                      : context.surfaceContainerHighColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: step >= 3
                      ? context.brandGold
                      : context.surfaceContainerHighColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
