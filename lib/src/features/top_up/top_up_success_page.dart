import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../widgets/elite_top_bar.dart';

@RoutePage()
class TopUpSuccessPage extends StatelessWidget {
  const TopUpSuccessPage({super.key, this.onDone});

  final VoidCallback? onDone;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: EliteTopBar(title: 'شحن الرصيد', showBack: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon with animated glow
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
                      value: '100.00 ر.س',
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
                      value: '1,350.00 ر.س',
                      textTheme: textTheme,
                      colors: colors,
                      highlight: true,
                    ),
                    const SizedBox(height: 12),
                    _ReceiptRow(
                      label: 'رقم المرجع',
                      value: '#TRX-00199',
                      textTheme: textTheme,
                      colors: colors,
                    ),
                    const SizedBox(height: 6),
                    _ReceiptRow(
                      label: 'التاريخ',
                      value: '26 يوليو 2026',
                      textTheme: textTheme,
                      colors: colors,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: onDone,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'العودة إلى المحفظة',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
