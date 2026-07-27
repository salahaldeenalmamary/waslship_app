import 'package:flutter/material.dart';

enum EliteTransactionType { income, outgoing, withdrawal, topup }

/// Single transaction row used in the Wallet screen.
/// Mirrors the TransactionItem component from waslship-elite.
class EliteTransactionItem extends StatelessWidget {
  const EliteTransactionItem({
    super.key,
    required this.type,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
  });

  final EliteTransactionType type;
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Color iconBg;
    Color iconColor;
    Color amountColor;

    switch (type) {
      case EliteTransactionType.income:
        iconBg = const Color(0xFF10B981).withValues(alpha: 0.1);
        iconColor = const Color(0xFF10B981);
        amountColor = const Color(0xFF10B981);
      case EliteTransactionType.outgoing:
        iconBg = colors.errorContainer;
        iconColor = colors.error;
        amountColor = colors.error;
      case EliteTransactionType.withdrawal:
        iconBg = colors.secondaryContainer;
        iconColor = colors.secondary;
        amountColor = colors.secondary;
      case EliteTransactionType.topup:
        iconBg = colors.primaryContainer;
        iconColor = colors.primary;
        amountColor = colors.primary;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
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
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: amountColor,
            ),
            textDirection: TextDirection.ltr,
          ),
        ],
      ),
    );
  }
}
