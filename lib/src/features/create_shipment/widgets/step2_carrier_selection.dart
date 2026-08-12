import '../../../imports/imports.dart';
import '../providers/create_shipment_provider.dart';

class Step2CarrierSelection extends ConsumerWidget {
  const Step2CarrierSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createShipmentProvider);
    final notifier = ref.read(createShipmentProvider.notifier);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with smart recommend toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.local_shipping,
                    color: context.brandGold,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'اختر شركة الشحن',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.brandGold,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => notifier.toggleSmartRecommend(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: state.smartRecommend
                        ? context.brandGold
                        : context.surfaceContainerHighColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: state.smartRecommend
                        ? [
                            BoxShadow(
                              color: context.brandGold.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 14,
                        color: state.smartRecommend
                            ? Colors.white
                            : context.outlineColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'ترشيح ذكي',
                        style: context.textTheme.labelSmall?.copyWith(
                          color: state.smartRecommend
                              ? Colors.white
                              : context.outlineColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Carrier Cards
          ...state.carriers.when(
            loading: () => [const Center(child: CircularProgressIndicator())],
            error: (err, _) => [
              Center(
                child: Text(
                  err.toString(),
                  style: TextStyle(color: Colors.red[400]),
                ),
              ),
            ],
            data: (carriers) => carriers.map((carrier) {
              final isSelected = state.selectedCarrierId == carrier.id;
              return _buildCarrierCard(
                context,
                carrier: carrier,
                isSelected: isSelected,
                isRecommended: carrier.isRecommended && state.smartRecommend,
                onTap: () => notifier.selectCarrier(carrier.id),
              );
            }).toList(),
          ),

          // Bottom spacing for fixed button
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildCarrierCard(
    BuildContext context, {
    required dynamic carrier,
    required bool isSelected,
    required bool isRecommended,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? context.brandGoldLight
              : context.surfaceContainerLowestColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? context.brandGold : context.outlineVariantColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? context.brandGold.withOpacity(0.1)
                  : context.onSurfaceColor.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Carrier Logo
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: context.surfaceContainerLowColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: context.outlineVariantColor,
                          ),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Image.asset(
                          carrier.logoAsset,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.local_shipping,
                              color: context.outlineVariantColor,
                              size: 24,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Carrier Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              carrier.name,
                              style: context.textTheme.titleSmall?.copyWith(
                                color: context.onSurfaceColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: context.outlineColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  carrier.estimatedTime,
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: context.onSurfaceVariantColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${carrier.price} SAR',
                            style: context.textTheme.titleMedium?.copyWith(
                              color: context.brandGold,
                            ),
                            textDirection: TextDirection.ltr,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: context.brandGoldLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              carrier.paymentType,
                              style: context.textTheme.labelSmall?.copyWith(
                                color: context.brandGold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Container(
                    height: 1,
                    color: context.outlineVariantColor.withOpacity(0.2),
                  ),
                  const SizedBox(height: 12),

                  // Bottom Row with badge and selection button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            carrier.badgeIcon,
                            size: 14,
                            color: context.brandGold,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            carrier.badge,
                            style: context.textTheme.labelSmall?.copyWith(
                              color: context.onSurfaceVariantColor,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? context.brandGold
                              : context.surfaceContainerHighColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSelected) ...[
                              const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                            ],
                            Text(
                              isSelected ? 'محدد' : 'اختيار',
                              style: context.textTheme.labelSmall?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : context.onSurfaceVariantColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Recommended Badge
            if (isRecommended)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: context.brandGold,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, size: 12, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'الأفضل توصية',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
