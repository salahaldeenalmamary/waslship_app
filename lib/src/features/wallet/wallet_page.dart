import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../app/routing/app_router.gr.dart';
import '../widgets/elite_top_bar.dart';
import '../widgets/elite_stat_card.dart';
import '../widgets/elite_transaction_item.dart';

@RoutePage()
class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    const gold = Color(0xFFC5A059);

    return Scaffold(
      backgroundColor: colors.surfaceContainer,
      appBar: EliteTopBar(title: 'المحفظة'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Balance Hero Card ──────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors.secondary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الرصيد المتاح',
                    style: textTheme.labelSmall?.copyWith(
                      color: Colors.white70,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '2,500.00',
                          style: textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'ر.س',
                          style: textTheme.titleMedium?.copyWith(
                            color: gold,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(
                    color: Colors.white.withValues(alpha: 0.12),
                    height: 1,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مبالغ COD قيد التحصيل',
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '1,200.00 ر.س',
                            style: textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          color: gold,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Quick Actions ──────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.credit_card_rounded,
                    label: 'شحن المحفظة',
                    onTap: () {
                      context.router.push(TopUpRoute());
                    },
                    colors: colors,
                    textTheme: textTheme,
                    primary: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'سحب الأرباح',
                    onTap: () {
                      context.router.push(BankTransferRoute());
                    },
                    colors: colors,
                    textTheme: textTheme,
                    primary: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Stats ──────────────────────────────────────────────────
            const Row(
              children: [
                Expanded(
                  child: EliteStatCard(
                    title: 'إجمالي الدخل',
                    value: '12,450 ر.س',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: EliteStatCard(title: 'المعاملات النشطة', value: '08'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Transactions ───────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'سجل المعاملات',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.primary,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'عرض الكل',
                    style: textTheme.labelSmall?.copyWith(
                      color: colors.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildTransactions(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactions() {
    return const Column(
      children: [
        EliteTransactionItem(
          type: EliteTransactionType.income,
          icon: Icons.account_balance_outlined,
          title: 'تحصيل قيمة شحنة',
          subtitle: '12:30pm • #TRX-98442',
          amount: '+450 ر.س',
        ),
        SizedBox(height: 10),
        EliteTransactionItem(
          type: EliteTransactionType.outgoing,
          icon: Icons.local_shipping_outlined,
          title: 'رسوم توصيل',
          subtitle: '11:15am • #TRX-87122',
          amount: '-25 ر.س',
        ),
        SizedBox(height: 10),
        EliteTransactionItem(
          type: EliteTransactionType.withdrawal,
          icon: Icons.arrow_upward_rounded,
          title: 'سحب أرباح للبنك',
          subtitle: 'أمس • #TRX-77651',
          amount: '-1,000 ر.س',
        ),
        SizedBox(height: 10),
        EliteTransactionItem(
          type: EliteTransactionType.topup,
          icon: Icons.credit_card_rounded,
          title: 'شحن محفظة (Mada)',
          subtitle: '04 مايو • #TRX-55421',
          amount: '+500 ر.س',
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.colors,
    required this.textTheme,
    required this.primary,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final ColorScheme colors;
  final TextTheme textTheme;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: colors.outlineVariant.withValues(alpha: 0.4),
          ),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: primary
                    ? colors.primaryContainer
                    : colors.secondaryContainer.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: primary ? colors.primary : colors.secondary,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
