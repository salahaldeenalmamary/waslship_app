import '../../imports/imports.dart';
import '../widgets/elite_top_bar.dart';
import '../widgets/elite_stat_card.dart';
import '../widgets/elite_transaction_item.dart';
import '../../data/repositories/wallet/wallet_dtos.dart';
import 'providers/wallet_providers.dart';

@RoutePage()
class WalletPage extends HookConsumerWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    const gold = Color(0xFFC5A059);

    final walletState = ref.watch(walletNotifierProvider);
    final walletNotifier = ref.read(walletNotifierProvider.notifier);

    // Load on mount
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        walletNotifier.refresh();
      });
      return null;
    }, []);

    final isLoading =
        walletState.isLoadingDashboard && walletState.dashboard == null;

    return Scaffold(
      backgroundColor: colors.surfaceContainer,
      appBar: const EliteTopBar(title: 'المحفظة'),
      body: RefreshIndicator(
        onRefresh: walletNotifier.refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Balance Hero Card ────────────────────────────────────
              _BalanceCard(
                isLoading: isLoading,
                availableBalance: walletState.availableBalance,
                codPending: walletState.codPending,
                currency: walletState.currency,
                gold: gold,
                textTheme: textTheme,
              ),
              const SizedBox(height: 16),

              // ── Quick Actions ────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _QuickActionButton(
                      icon: Icons.credit_card_rounded,
                      label: 'شحن المحفظة',
                      onTap: () => context.router.push(TopUpRoute()),
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
                      onTap: () => context.router.push(BankTransferRoute()),
                      colors: colors,
                      textTheme: textTheme,
                      primary: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Stats ────────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: EliteStatCard(
                      title: 'إجمالي الدخل',
                      value: isLoading
                          ? '—'
                          : '${walletState.totalIncome.toStringAsFixed(2)} ${walletState.currency}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: EliteStatCard(
                      title: 'المعاملات النشطة',
                      value: isLoading
                          ? '—'
                          : walletState.activeTransactions.toString(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Error banner ─────────────────────────────────────────
              if (walletState.errorMessage != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: colors.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: colors.onErrorContainer,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          walletState.errorMessage!,
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.onErrorContainer,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: walletNotifier.refresh,
                        child: Text(
                          'إعادة المحاولة',
                          style: TextStyle(color: colors.onErrorContainer),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ── Recent Transactions ──────────────────────────────────
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
                ],
              ),
              const SizedBox(height: 8),
              _TransactionList(
                isLoading: isLoading,
                transactions: walletState.recentTransactions,
                colors: colors,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Balance Hero Card
// ────────────────────────────────────────────────────────────────────────────

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.isLoading,
    required this.availableBalance,
    required this.codPending,
    required this.currency,
    required this.gold,
    required this.textTheme,
  });

  final bool isLoading;
  final double availableBalance;
  final double codPending;
  final String currency;
  final Color gold;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
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
                if (isLoading) const _Shimmer(width: 120, height: 40) else Text(
                        availableBalance.toStringAsFixed(2),
                        style: textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                const SizedBox(width: 6),
                Text(
                  currency,
                  style: textTheme.titleMedium?.copyWith(
                    color: gold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.white.withValues(alpha: 0.12), height: 1),
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
                  if (isLoading)
                    const _Shimmer(width: 80, height: 20)
                  else
                    Text(
                      '${codPending.toStringAsFixed(2)} $currency',
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
                  color: Color(0xFFC5A059),
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Transaction List
// ────────────────────────────────────────────────────────────────────────────

class _TransactionList extends StatelessWidget {
  const _TransactionList({
    required this.isLoading,
    required this.transactions,
    required this.colors,
  });

  final bool isLoading;
  final List<WalletTransactionDto> transactions;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Column(
        children: List.generate(
          3,
          (_) => const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: _Shimmer(height: 72, width: double.infinity),
          ),
        ),
      );
    }

    if (transactions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 48,
                color: colors.onSurfaceVariant.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 12),
              Text(
                'لا توجد معاملات حتى الآن',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: transactions.indexed.map((entry) {
        final (i, tx) = entry;
        return Padding(
          padding: EdgeInsets.only(
            bottom: i < transactions.length - 1 ? 10 : 0,
          ),
          child: EliteTransactionItem(
            type: _mapType(tx),
            icon: _mapIcon(tx.type),
            title: tx.description ?? _mapTitle(tx.type),
            subtitle: '${_formatDate(tx.createdAt)} • #${tx.transactionNumber}',
            amount:
                '${tx.isCredit ? '+' : '-'}${tx.amount.toStringAsFixed(2)} ر.س',
          ),
        );
      }).toList(),
    );
  }

  EliteTransactionType _mapType(WalletTransactionDto tx) {
    if (!tx.isCredit) {
      switch (tx.type) {
        case 'Withdrawal':
          return EliteTransactionType.withdrawal;
        case 'ShipmentCharge':
        case 'Fee':
        case 'Reserved':
          return EliteTransactionType.outgoing;
        default:
          return EliteTransactionType.outgoing;
      }
    }
    switch (tx.type) {
      case 'Deposit':
        return EliteTransactionType.topup;
      default:
        return EliteTransactionType.income;
    }
  }

  IconData _mapIcon(String type) {
    switch (type) {
      case 'Deposit':
        return Icons.credit_card_rounded;
      case 'Withdrawal':
        return Icons.arrow_upward_rounded;
      case 'ShipmentCharge':
        return Icons.local_shipping_outlined;
      case 'ShipmentRefund':
        return Icons.assignment_return_outlined;
      case 'CODSettlement':
        return Icons.account_balance_outlined;
      case 'Fee':
        return Icons.receipt_outlined;
      case 'Reserved':
        return Icons.lock_clock_outlined;
      case 'ReservationReleased':
        return Icons.lock_open_outlined;
      default:
        return Icons.swap_horiz_rounded;
    }
  }

  String _mapTitle(String type) {
    switch (type) {
      case 'Deposit':
        return 'شحن المحفظة';
      case 'Withdrawal':
        return 'سحب أرباح للبنك';
      case 'ShipmentCharge':
        return 'رسوم توصيل';
      case 'ShipmentRefund':
        return 'استرداد شحنة';
      case 'CODSettlement':
        return 'تحصيل قيمة شحنة';
      case 'Fee':
        return 'رسوم إدارية';
      case 'Reserved':
        return 'مبلغ محجوز';
      case 'ReservationReleased':
        return 'تحرير المبلغ المحجوز';
      default:
        return 'معاملة';
    }
  }

  String _formatDate(DateTime dt) {
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
    return '${dt.day} ${months[dt.month - 1]}';
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Shimmer placeholder
// ────────────────────────────────────────────────────────────────────────────

class _Shimmer extends StatelessWidget {
  const _Shimmer({required this.height, required this.width});
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.onSurface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Quick Action Button (unchanged)
// ────────────────────────────────────────────────────────────────────────────

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
