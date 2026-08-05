import '../../data/repositories/payment/payment_dtos.dart';
import '../../imports/imports.dart';
import '../widgets/elite_top_bar.dart';
import 'providers/payment_notifier.dart';
import 'widgets/payment_method_option.dart';

@RoutePage()
class TopUpPage extends HookConsumerWidget {
  const TopUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hooks for local state
    final step = useState(1);
    final amount = useState(100.0);
    final customController = useTextEditingController();
    final selectedMethod = useState<PaymentMethodDto?>(null);

    // Payment state
    final paymentState = ref.watch(paymentNotifierProvider);
    final paymentNotifier = ref.read(paymentNotifierProvider.notifier);

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    const presets = [50.0, 100.0, 200.0, 500.0];

    final parsedCustom = double.tryParse(customController.text);
    final double displayAmount = parsedCustom ?? amount.value;
    final bool isValidAmount = displayAmount >= 10 && displayAmount <= 10000;

    // ============================================
    // Step 2: Initiate Payment
    // ============================================
    Future<Result<InitiatePaymentResponseDto?>> _handleInitiatePayment() async {
      if (!isValidAmount) {
        return const Result.err('المبلغ يجب أن يكون بين 10 و 10,000 ر.س');
      }

      paymentNotifier.setAmount(displayAmount);

      final request = InitiatePaymentRequestDto(
        initiationRequest: InitiationRequestDto(
          amount: displayAmount,
          currency: 'SAR',
        ),
        currency: 'SAR',
      );

      final result = await paymentNotifier.initiatePayment(request);

      result.fold(
        onOk: (response) {
          // Move to step 2 after successful initiation
          step.value = 2;
        },
        onErr: (message, _) {
          AppToast.error(context, message: message);
        },
      );

      return result;
    }

    // ============================================
    // Step 3: Execute Payment
    // ============================================
    Future<Result<ExecutePaymentResponseDto?>> _handleExecutePayment() async {
      if (selectedMethod.value == null) {
        return const Result.err('يرجى اختيار وسيلة الدفع');
      }

      if (paymentState.depositId == null) {
        return const Result.err('رقم الإيداع غير متوفر');
      }

      final request = ExecutePaymentRequestDto(
        depositId: paymentState.depositId!,
        paymentMethodId: selectedMethod.value!.id,
      );

      final result = await paymentNotifier.executePayment(request);

      result.fold(
        onOk: (response) {
          if (response?.hasPaymentUrl ?? false) {
            context.router.push(
              PaymentWebViewRoute(
                url: response!.executePaymentResult.paymentUrl!,
                depositId: paymentState.depositId!,
                amount: displayAmount,
              ),
            );
          } else {
            AppToast.success(context, message: 'تم الدفع بنجاح');
            context.router.maybePop();
          }
        },
        onErr: (message, _) {
          AppToast.error(context, message: message);
        },
      );

      return result;
    }

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: EliteTopBar(
        title: 'شحن الرصيد',
        showBack: true,
        onBack: () {
          if (step.value > 1) {
            step.value = step.value - 1;

            if (step.value == 1) {
              paymentNotifier.resetPayment();
              selectedMethod.value = null;
            }
          } else {
            context.router.maybePop();
          }
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).padding.bottom + 20,
        ),
        decoration: BoxDecoration(
          color: colors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (step.value == 1)
              AsyncButton.primary(
                label: 'المتابعة للدفع',
                icon: Icons.chevron_left_rounded,
                enabled: isValidAmount,
                onPressed: _handleInitiatePayment,
                showSuccessToast: false,
              )
            else if (step.value == 2 && paymentState.hasMethods) ...[
              AsyncButton.primary(
                label: 'الدفع الآن ${displayAmount.toStringAsFixed(2)} ر.س',
                icon: Icons.payment,
                onPressed: _handleExecutePayment,
                successMessage: 'تم الدفع بنجاح',
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'بالضغط على الدفع، أنت توافق على شروط وأحكام واصل شيب',
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (step.value != 2)
              _buildSummaryCard(
                step: step.value,
                displayAmount: displayAmount,
                colors: colors,
                textTheme: textTheme,
              ),
            const SizedBox(height: 24),

            // ============================================
            // STEP 1: Amount Selection
            // ============================================
            if (step.value == 1) ...[
              _buildAmountSelection(
                amount: amount,
                customController: customController,
                presets: presets,
                colors: colors,
                textTheme: textTheme,
              ),
            ]
            // ============================================
            // STEP 2: Select Payment Method & Pay
            // ============================================
            else if (step.value == 2) ...[
              if (paymentState.isLoading &&
                  paymentState.availableMethods.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (paymentState.hasMethods) ...[
                Text(
                  'اختر وسيلة الدفع',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.primary,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 12),
                ...paymentState.availableMethods.map((method) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: PaymentMethodOption(
                      method: method,
                      selected: selectedMethod.value?.id == method.id,
                      onTap: () => selectedMethod.value = method,
                      colors: colors,
                      textTheme: textTheme,
                    ),
                  );
                }),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: colors.secondaryContainer.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: colors.secondaryContainer.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline_rounded,
                        size: 15,
                        color: colors.secondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'نظام دفع مشفر بالكامل وآمن بنسبة 100%',
                        style: textTheme.labelMedium?.copyWith(
                          color: colors.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Error state
                _buildErrorState(
                  message: paymentState.errorMessage ?? 'حدث خطأ غير متوقع',
                  onRetry: _handleInitiatePayment,
                  colors: colors,
                  textTheme: textTheme,
                ),
              ],
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ============================================
  // Summary Card
  // ============================================
  Widget _buildSummaryCard({
    required int step,
    required double displayAmount,
    required ColorScheme colors,
    required TextTheme textTheme,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: step == 1 ? const Color(0xFF111111) : colors.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: step != 1
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Text(
            step == 1 ? 'الرصيد الحالي' : 'إجمالي المبلغ',
            style: textTheme.labelSmall?.copyWith(
              color: step == 1
                  ? Colors.white70
                  : colors.onPrimaryContainer.withValues(alpha: 0.7),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            mainAxisSize: step != 1 ? MainAxisSize.min : MainAxisSize.max,
            children: [
              Text(
                step == 1 ? '1,250' : displayAmount.toStringAsFixed(2),
                style: textTheme.headlineMedium?.copyWith(
                  color: step == 1 ? Colors.white : colors.onPrimaryContainer,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'ر.س',
                style: textTheme.titleMedium?.copyWith(
                  color: step == 1
                      ? const Color(0xFFC5A059)
                      : colors.onPrimaryContainer.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (step == 1) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.shield_rounded,
                  size: 14,
                  color: Colors.white70,
                ),
                const SizedBox(width: 6),
                Text(
                  'عضوية بريميوم إيليت مفعلة',
                  style: textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ============================================
  // Error State
  // ============================================
  Widget _buildErrorState({
    required String message,
    required VoidCallback onRetry,
    required ColorScheme colors,
    required TextTheme textTheme,
  }) {
    return Column(
      children: [
        const SizedBox(height: 32),
        Icon(Icons.error_outline, size: 48, color: colors.error),
        const SizedBox(height: 16),
        Text(
          message,
          style: textTheme.bodyMedium?.copyWith(color: colors.error),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // ============================================
  // Amount Selection
  // ============================================
  Widget _buildAmountSelection({
    required ValueNotifier<double> amount,
    required TextEditingController customController,
    required List<double> presets,
    required ColorScheme colors,
    required TextTheme textTheme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر مبلغ الشحن',
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.primary,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: presets.map((val) {
            final selected =
                amount.value == val && customController.text.isEmpty;
            return GestureDetector(
              onTap: () {
                customController.clear();
                amount.value = val;
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: selected
                      ? colors.primaryContainer.withValues(alpha: 0.5)
                      : colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected
                        ? colors.primary
                        : colors.outlineVariant.withValues(alpha: 0.4),
                    width: selected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$val',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colors.primary,
                      ),
                    ),
                    Text(
                      'ر.س',
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Text(
          'أو أدخل مبلغاً آخر',
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.primary,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: customController,
          keyboardType: TextInputType.number,
          onChanged: (_) =>
              amount.value = double.tryParse(customController.text) ?? 0,
          decoration: InputDecoration(
            hintText: '0.00',
            suffixText: 'ر.س',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.outlineVariant),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'الحد الأدنى 10 ر.س - الحد الأقصى 10,000 ر.س',
          style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}
