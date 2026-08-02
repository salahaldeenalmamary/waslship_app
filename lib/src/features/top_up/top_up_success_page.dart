
import '../../data/repositories/payment/payment_dtos.dart';
import '../../imports/imports.dart';
import '../widgets/elite_top_bar.dart';
import 'providers/payment_providers.dart';

@RoutePage()
class TopUpSuccessPage extends HookConsumerWidget {
  final String? depositId;
  final double? amount;
  final String? transactionId;

  const TopUpSuccessPage({
    super.key,
    @queryParam this.depositId,
    @queryParam this.amount,
    @queryParam this.transactionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final paymentState = ref.watch(paymentNotifierProvider);
    final paymentNotifier = ref.read(paymentNotifierProvider.notifier);

    useEffect(() {
      if (depositId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final request = VerifyPaymentRequestDto(depositId: depositId!);
          paymentNotifier.verifyPayment(request);
        });
      }
      return null;
    }, [depositId]);

    final displayAmount = amount ?? paymentState.amount;
    final referenceId =
        transactionId ??
        paymentState.verificationResult?.transactionId ??
        paymentState.executionResult?.transactionId ??
        'N/A';
    final paymentDate = DateTime.now();
    final formattedDate =
        '${paymentDate.day} ${_getMonthName(paymentDate.month)} ${paymentDate.year}';

    // Calculate new balance (example: current + added)
    const currentBalance = 1250.0;
    final newBalance = currentBalance + displayAmount;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: const EliteTopBar(title: 'شحن الرصيد', showBack: false),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withValues(alpha: 0.3),
                      blurRadius: 32,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 52,
                  color: Color(0xFF10B981),
                ),
              ),
              const SizedBox(height: 24),

              // Success Title
              Text(
                'تمت العملية بنجاح!',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'تم إضافة الرصيد إلى محفظتك بنجاح.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Receipt Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colors.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  children: [
                    _ReceiptRow(
                      label: 'المبلغ المضاف',
                      value: '${displayAmount.toStringAsFixed(2)} ر.س',
                      textTheme: textTheme,
                      colors: colors,
                      highlight: true,
                    ),
                    const SizedBox(height: 12),
                    _ReceiptRow(
                      label: 'رسوم المعالجة',
                      value: '0.00 ر.س',
                      textTheme: textTheme,
                      colors: colors,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Divider(
                        height: 1,
                        color: colors.outlineVariant.withValues(alpha: 0.4),
                      ),
                    ),
                    _ReceiptRow(
                      label: 'الرصيد الجديد',
                      value: '${newBalance.toStringAsFixed(2)} ر.س',
                      textTheme: textTheme,
                      colors: colors,
                      highlight: true,
                    ),
                    const SizedBox(height: 12),
                    _ReceiptRow(
                      label: 'رقم المرجع',
                      value: '#$referenceId',
                      textTheme: textTheme,
                      colors: colors,
                    ),
                    const SizedBox(height: 6),
                    _ReceiptRow(
                      label: 'التاريخ',
                      value: formattedDate,
                      textTheme: textTheme,
                      colors: colors,
                    ),
                    if (depositId != null) ...[
                      const SizedBox(height: 6),
                      _ReceiptRow(
                        label: 'رقم الإيداع',
                        value: depositId!.substring(0, 8) + '...',
                        textTheme: textTheme,
                        colors: colors,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Back to Wallet Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () {
                    paymentNotifier.resetPayment();

                    context.router.replaceAll([const AppShellRoute()]);
                  },
                  icon: const Icon(Icons.account_balance_wallet_rounded),
                  label: const Text(
                    'العودة إلى المحفظة',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share_rounded, size: 18),
                  label: const Text(
                    'مشاركة الإيصال',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: BorderSide(color: colors.outlineVariant),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return months[month - 1];
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({
    required this.label,
    required this.value,
    required this.textTheme,
    required this.colors,
    this.highlight = false,
  });

  final String label;
  final String value;
  final TextTheme textTheme;
  final ColorScheme colors;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: highlight ? colors.onSurface : colors.onSurfaceVariant,
            fontWeight: highlight ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            color: highlight ? colors.primary : colors.onSurface,
            fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
