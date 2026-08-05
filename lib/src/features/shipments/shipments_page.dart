import 'package:flutter/material.dart';
import '../../data/repositories/shipments/shipment_dtos.dart';
import '../../imports/packages_imports.dart';
import '../widgets/elite_top_bar.dart';
import '../widgets/elite_shipment_card.dart';
import '../widgets/elite_empty_state.dart';
import 'providers/shipments_providers.dart';

enum ShipmentTab {
  all('الكل', null),
  inTransit('قيد التوصيل', 'InTransit'),
  delivered('تم التسليم', 'Delivered'),
  pending('معلق', 'Pending'),
  cancelled('ملغي', 'Cancelled');

  const ShipmentTab(this.label, this.apiStatus);
  final String label;
  final String? apiStatus;
}

@RoutePage()
class ShipmentsPage extends HookConsumerWidget {
  const ShipmentsPage({super.key, this.onTrack});

  final VoidCallback? onTrack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final scrollController = useScrollController();

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final state = ref.watch(shipmentsNotifierProvider);
    final notifier = ref.read(shipmentsNotifierProvider.notifier);

    useEffect(() {
      void onScroll() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          ref.read(shipmentsNotifierProvider.notifier).loadShipments();
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    final activeTab = ShipmentTab.values.firstWhere(
      (tab) => tab.apiStatus == state.activeStatus,
      orElse: () => ShipmentTab.all,
    );

    return Scaffold(
      backgroundColor: colors.surfaceContainer,
      appBar: const EliteTopBar(
        title: 'WaslShip - قائمة الشحنات',
        showMenu: true,
      ),
      body: Column(
        children: [
          // ── Filters ────────────────────────────────────────────────
          Column(
            children: [
              const SizedBox(height: 12),

              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemCount: ShipmentTab.values.length,
                  itemBuilder: (context, i) {
                    final tab = ShipmentTab.values[i];
                    final active = activeTab == tab;
                    return GestureDetector(
                      onTap: () => notifier.setStatusFilter(tab.apiStatus),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: active
                              ? colors.primary
                              : colors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tab.label,
                          style: textTheme.labelMedium?.copyWith(
                            color: active
                                ? colors.onPrimary
                                : colors.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              // Search field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: searchController,
                  textDirection: TextDirection.rtl,
                  onChanged: notifier.setSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'البحث برقم التتبع...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: colors.surfaceContainerLow,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    suffixIcon: state.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              searchController.clear();
                              notifier.setSearchQuery('');
                            },
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Divider(height: 1, color: colors.outlineVariant),
            ],
          ),

          // ── List / Loading / Error ──────────────────────────────────
          Expanded(
            child: state.shipments.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => RefreshIndicator(
                onRefresh: notifier.refresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: 400,
                    child: EliteEmptyState(
                      icon: Icons.error_outline,
                      title: 'حدث خطأ',
                      description: err.toString(),
                    ),
                  ),
                ),
              ),
              data: (items) => items.isEmpty
                  ? RefreshIndicator(
                      onRefresh: notifier.refresh,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: 400,
                          child: EliteEmptyState(
                            icon: Icons.inventory_2_outlined,
                            title: 'لا توجد شحنات',
                            description: state.searchQuery.isNotEmpty
                                ? 'لم يتم العثور على نتائج تطابق بحثك.'
                                : 'لا يوجد لديك أي شحنات في هذه الفئة حالياً.',
                          ),
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: notifier.refresh,
                      child: ListView.separated(
                        controller: scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemCount: items.length + (state.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, i) {
                          if (i == items.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return EliteShipmentCard(
                            shipment: _toCardData(items[i]),
                            onTrack: onTrack,
                          );
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /// Maps API [ShipmentDto] → [EliteShipmentData] for the card widget.
  EliteShipmentData _toCardData(ShipmentDto dto) {
    EliteShipmentStatus statusType;
    switch (dto.status) {
      case 'Delivered':
        statusType = EliteShipmentStatus.delivered;
      case 'InTransit':
      case 'Shipped':
        statusType = EliteShipmentStatus.inTransit;
      case 'Failed':
      case 'Cancelled':
        statusType = EliteShipmentStatus.returned;
      default:
        statusType = EliteShipmentStatus.pending;
    }

    return EliteShipmentData(
      id: dto.trackingNumber,
      date: dto.createdAt ?? '',
      status: _arabicStatus(dto.status),
      customer: dto.recipientName,
      location: '${dto.senderCity} ← ${dto.recipientCity}',
      count: 1,
      statusType: statusType,
    );
  }

  String _arabicStatus(String status) {
    switch (status) {
      case 'Delivered':
        return 'تم التسليم';
      case 'InTransit':
        return 'قيد التوصيل';
      case 'Shipped':
        return 'تم الشحن';
      case 'Pending':
        return 'معلق';
      case 'Cancelled':
        return 'ملغي';
      case 'Failed':
        return 'فشل';
      default:
        return status;
    }
  }
}
