import '../../../imports/imports.dart';
import '../providers/create_shipment_provider.dart';

class SuccessToast extends ConsumerWidget {
  const SuccessToast({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showToast = ref.watch(
      createShipmentProvider.select((s) => s.showSuccessToast),
    );

    if (!showToast) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.successColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: context.successColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'تم حفظ مسودة الشحنة بنجاح! يمكنك العودة إليها وإكمالها لاحقاً.',
              style: context.textTheme.labelMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
