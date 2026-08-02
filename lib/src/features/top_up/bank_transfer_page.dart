import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../widgets/elite_top_bar.dart';

@RoutePage()
class BankTransferPage extends StatefulWidget {
  const BankTransferPage({super.key, this.onConfirm});

  final VoidCallback? onConfirm;

  @override
  State<BankTransferPage> createState() => _BankTransferPageState();
}

class _BankTransferPageState extends State<BankTransferPage> {
  String _selectedBank = 'rajhi';
  final _amountController = TextEditingController();
  String _receiptFileName = '';

  static const _banks = [
    _BankOption(
      id: 'rajhi',
      name: 'مصرف الراجحي',
      sub: 'المملكة العربية السعودية',
    ),
    _BankOption(id: 'snb', name: 'البنك الأهلي السعودي', sub: 'SNB'),
    _BankOption(
      id: 'riyad',
      name: 'بنك الرياض',
      sub: 'المملكة العربية السعودية',
    ),
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final amountText = _amountController.text;
    final canSubmit = amountText.isNotEmpty && _receiptFileName.isNotEmpty;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: const EliteTopBar(title: 'التحويل البنكي', showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress pills
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Pill(width: 8, active: false, colors: colors),
                const SizedBox(width: 8),
                _Pill(width: 32, active: true, colors: colors),
                const SizedBox(width: 8),
                _Pill(width: 8, active: false, colors: colors),
              ],
            ),
            const SizedBox(height: 24),

            // Bank selection
            Text(
              'اختر البنك المحول إليه',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            ..._banks.map((bank) {
              final selected = _selectedBank == bank.id;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedBank = bank.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: selected
                          ? colors.primaryContainer.withValues(alpha: 0.3)
                          : colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? colors.primary
                            : colors.outlineVariant,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: colors.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: colors.outlineVariant),
                          ),
                          child: Icon(
                            Icons.account_balance_outlined,
                            color: colors.primary,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bank.name,
                                style: textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                bank.sub,
                                style: textTheme.bodySmall?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Radio<String>(
                          value: bank.id,
                          groupValue: _selectedBank,
                          onChanged: (v) => setState(() => _selectedBank = v!),
                          activeColor: colors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),

            // Amount
            Text(
              'مبلغ التحويل',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: '0.00',
                suffixText: 'ر.س',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Receipt upload
            Text(
              'إثبات التحويل',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // Simulate picking a file
                setState(() => _receiptFileName = 'receipt_transfer.jpg');
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  color: _receiptFileName.isNotEmpty
                      ? colors.primaryContainer.withValues(alpha: 0.2)
                      : colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _receiptFileName.isNotEmpty
                        ? colors.primary
                        : colors.outlineVariant,
                    style: BorderStyle.solid,
                    width: _receiptFileName.isNotEmpty ? 2 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.upload_rounded,
                        size: 30,
                        color: colors.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _receiptFileName.isNotEmpty
                          ? 'تم اختيار: $_receiptFileName'
                          : 'ارفع صورة الإيصال',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (_receiptFileName.isEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'يدعم JPG, PNG (بحد أقصى 5 ميجابايت)',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Summary
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: colors.outlineVariant.withValues(alpha: 0.4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المبلغ المراد شحنه',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        amountText.isEmpty ? '0.00' : amountText,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'ريال سعودي',
                        style: textTheme.titleSmall?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(
                    height: 1,
                    color: colors.outlineVariant.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 15,
                        color: colors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'سيتم إضافة الرصيد لمحفظتك فور التأكد من صحة الحوالة',
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: canSubmit ? widget.onConfirm : null,
                icon: const Icon(Icons.send_rounded),
                label: const Text(
                  'تأكيد وإرسال',
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
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _BankOption {
  const _BankOption({required this.id, required this.name, required this.sub});

  final String id;
  final String name;
  final String sub;
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.width,
    required this.active,
    required this.colors,
  });

  final double width;
  final bool active;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 8,
      decoration: BoxDecoration(
        color: active ? colors.primary : colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
