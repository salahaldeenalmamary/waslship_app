import '../../imports/imports.dart';
import 'providers/create_shipment_provider.dart';
import 'widgets/draft_banner.dart';
import 'widgets/step1_shipment_form.dart';
import 'widgets/step2_carrier_selection.dart';
import 'widgets/step3_confirmation.dart';
import 'widgets/step_progress_indicator.dart';
import 'widgets/success_toast.dart';

class CreateShipmentPage extends ConsumerWidget {
  const CreateShipmentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createShipmentProvider);
    final notifier = ref.read(createShipmentProvider.notifier);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // Show submission errors as SnackBar
    ref.listen<AsyncValue<void>>(
      createShipmentProvider.select((s) => s.submission),
      (_, next) {
        next.whenOrNull(
          error: (err, _) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(err.toString()),
              backgroundColor: context.errorColor,
            ),
          ),
        );
      },
    );

    return Scaffold(
      backgroundColor: context.surfaceColor,
      appBar: AppBar(
        title: Text(
          'إنشاء شحنة جديدة',
          style: context.textTheme.titleMedium?.copyWith(
            color: context.onSurfaceColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: context.surfaceContainerLowestColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: context.onSurfaceColor,
          ),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const DraftBanner(),
                          const SuccessToast(),
                          const StepProgressIndicator(),
                          const SizedBox(height: 24),
                          if (state.currentStep == 1)
                            const Step1ShipmentForm()
                          else if (state.currentStep == 2)
                            const Step2CarrierSelection()
                          else if (state.currentStep == 3)
                            const Step3Confirmation(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Action Bar
            Container(
              padding: EdgeInsets.fromLTRB(20, 16, 20, bottomPadding + 16),
              decoration: BoxDecoration(
                color: context.surfaceContainerLowestColor.withOpacity(0.95),
                border: Border(
                  top: BorderSide(
                    color: context.outlineVariantColor,
                    width: 0.5,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.onSurfaceColor.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: _buildBottomActions(context, ref, state, notifier),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    WidgetRef ref,
    CreateShipmentState state,
    CreateShipmentNotifier notifier,
  ) {
    final isLoading = state.submission.isLoading;
    if (state.currentStep == 1) {
      return Row(
        children: [
          OutlinedButton.icon(
            onPressed: () => notifier.saveDraft(),
            icon: Icon(Icons.save_outlined, size: 16, color: context.brandGold),
            label: Text(
              'حفظ كمسودة',
              style: context.textTheme.labelSmall?.copyWith(
                color: context.onSurfaceColor,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              minimumSize: const Size(0, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: context.outlineVariantColor),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : () => notifier.nextStep(),
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.arrow_back, size: 18),
              label: Text(
                'المتابعة لاختيار الشركة',
                style: context.textTheme.titleSmall?.copyWith(
                  color: context.onPrimaryColor,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryColor,
                foregroundColor: context.onPrimaryColor,
                minimumSize: const Size(0, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                shadowColor: context.primaryColor.withOpacity(0.3),
              ),
            ),
          ),
        ],
      );
    } else if (state.currentStep == 2) {
      return Row(
        children: [
          OutlinedButton(
            onPressed: () => notifier.previousStep(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              minimumSize: const Size(0, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: context.primaryColor),
            ),
            child: Text(
              'السابق',
              style: context.textTheme.labelSmall?.copyWith(
                color: context.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: () => notifier.saveDraft(),
            icon: Icon(Icons.save_outlined, size: 15, color: context.brandGold),
            label: Text(
              'مسودة',
              style: context.textTheme.labelSmall?.copyWith(
                color: context.onSurfaceColor,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              minimumSize: const Size(0, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: context.outlineVariantColor),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => notifier.nextStep(),
              icon: const Icon(Icons.arrow_back, size: 16),
              label: Text(
                'مراجعة البيانات',
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.onPrimaryColor,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryColor,
                foregroundColor: context.onPrimaryColor,
                minimumSize: const Size(0, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                shadowColor: context.primaryColor.withOpacity(0.3),
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          ElevatedButton.icon(
            onPressed: isLoading ? null : () => notifier.submitShipment(),
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.send, size: 20),
            label: Text(
              'إصدار الشحنة',
              style: context.textTheme.titleSmall?.copyWith(
                color: context.onPrimaryColor,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primaryColor,
              foregroundColor: context.onPrimaryColor,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              shadowColor: context.primaryColor.withOpacity(0.3),
              disabledBackgroundColor: context.surfaceContainerHighColor,
              disabledForegroundColor: context.outlineColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => notifier.goToStep(1),
                  icon: Icon(
                    Icons.edit,
                    size: 16,
                    color: context.onSurfaceVariantColor,
                  ),
                  label: Text(
                    'تعديل البيانات',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.onSurfaceVariantColor,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(color: context.outlineVariantColor),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.router.maybePop(),
                  icon: Icon(
                    Icons.home,
                    size: 16,
                    color: context.onSurfaceVariantColor,
                  ),
                  label: Text(
                    'العودة للرئيسية',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.onSurfaceVariantColor,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(color: context.outlineVariantColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
}
