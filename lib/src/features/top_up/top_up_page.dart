import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../widgets/elite_top_bar.dart';

/// Elite top-up page with 2 steps: amount selection → payment method.
/// Mirrors the TopUp screen from waslship-elite.
@RoutePage(name: 'TopUpRoute')
class TopUpPage extends StatefulWidget {
  const TopUpPage({super.key, this.onConfirm, this.onBankTransfer});

  final VoidCallback? onConfirm;
  final VoidCallback? onBankTransfer;

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

enum _PaymentMethod { apple, mada, bank }

class _TopUpPageState extends State<TopUpPage> {
  int _step = 1;
  double _amount = 100;
  final _customController = TextEditingController();
  _PaymentMethod _method = _PaymentMethod.apple;
  bool _saveCard = false;

  static const _presets = [50.0, 100.0, 200.0, 500.0];

  double get _displayAmount {
    final parsed = double.tryParse(_customController.text);
    return parsed != null ? parsed : _amount;
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: EliteTopBar(
        title: 'شحن الرصيد',
        showBack: true,
        onBack: () {
          if (_step == 2) {
            setState(() => _step = 1);
          } else {
            Navigator.maybePop(context);
          }
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Summary Card ───────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _step == 1
                    ? const Color(0xFF111111)
                    : colors.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: _step == 2
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    _step == 1 ? 'الرصيد الحالي' : 'إجمالي المبلغ',
                    style: textTheme.labelSmall?.copyWith(
                      color: _step == 1
                          ? Colors.white70
                          : colors.onPrimaryContainer.withValues(alpha: 0.7),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    mainAxisSize: _step == 2
                        ? MainAxisSize.min
                        : MainAxisSize.max,
                    children: [
                      Text(
                        _step == 1
                            ? '1,250'
                            : _displayAmount.toStringAsFixed(2),
                        style: textTheme.headlineMedium?.copyWith(
                          color: _step == 1
                              ? Colors.white
                              : colors.onPrimaryContainer,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'ر.س',
                        style: textTheme.titleMedium?.copyWith(
                          color: _step == 1
                              ? const Color(0xFFC5A059)
                              : colors.onPrimaryContainer.withValues(
                                  alpha: 0.8,
                                ),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  if (_step == 1) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.shield_rounded,
                          size: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'عضوية بريميوم إيليت مفعلة',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            if (_step == 1) ...[
              // Amount presets
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
                children: _presets.map((val) {
                  final selected =
                      _amount == val && _customController.text.isEmpty;
                  return GestureDetector(
                    onTap: () {
                      _customController.clear();
                      setState(() => _amount = val);
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
                controller: _customController,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: '0.00',
                  suffixText: 'ر.س',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'الحد الأدنى 10 ر.س - الحد الأقصى 10,000 ر.س',
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.chevron_left_rounded),
                  label: const Text(
                    'المتابعة للدفع',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  onPressed: (_displayAmount >= 10 && _displayAmount <= 10000)
                      ? () => setState(() => _step = 2)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ] else ...[
              // Payment methods
              Text(
                'اختر وسيلة الدفع',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: 12),
              _PaymentOption(
                icon: Icons.phone_iphone_rounded,
                title: 'Apple Pay',
                subtitle: 'دفع سريع وآمن بنقرة واحدة',
                selected: _method == _PaymentMethod.apple,
                onTap: () => setState(() => _method = _PaymentMethod.apple),
                colors: colors,
                textTheme: textTheme,
              ),
              const SizedBox(height: 10),
              _PaymentOption(
                icon: Icons.credit_card_rounded,
                title: 'بطاقة مدى / ائتمان',
                subtitle: 'Visa, Mastercard, Mada',
                selected: _method == _PaymentMethod.mada,
                onTap: () => setState(() => _method = _PaymentMethod.mada),
                colors: colors,
                textTheme: textTheme,
              ),
              const SizedBox(height: 10),
              _PaymentOption(
                icon: Icons.account_balance_outlined,
                title: 'تحويل بنكي',
                subtitle: 'التحويل إلى حساباتنا المحلية',
                selected: _method == _PaymentMethod.bank,
                onTap: () => setState(() => _method = _PaymentMethod.bank),
                colors: colors,
                textTheme: textTheme,
              ),
              const SizedBox(height: 16),
              // Save card toggle
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.outlineVariant),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.bookmark_border_rounded,
                      color: colors.secondary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'حفظ البطاقة لاستخدامها لاحقاً',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Switch(
                      value: _saveCard,
                      onChanged: (v) => setState(() => _saveCard = v),
                      activeColor: colors.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.double_arrow_rounded),
                  label: const Text(
                    'ادفع وأكد الشحن',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  onPressed: _method == _PaymentMethod.bank
                      ? widget.onBankTransfer
                      : widget.onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
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
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    required this.colors,
    required this.textTheme,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  final ColorScheme colors;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? colors.primaryContainer.withValues(alpha: 0.3)
              : colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? colors.primary : colors.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: colors.primary, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? colors.primary : colors.outlineVariant,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: colors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
