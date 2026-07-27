import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../widgets/elite_top_bar.dart';
import '../widgets/elite_shipment_card.dart';
import '../widgets/elite_empty_state.dart';

@RoutePage()
class ShipmentsPage extends StatefulWidget {
  const ShipmentsPage({super.key, this.onTrack});

  final VoidCallback? onTrack;

  @override
  State<ShipmentsPage> createState() => _ShipmentsPageState();
}

class _ShipmentsPageState extends State<ShipmentsPage> {
  String _activeTab = 'الكل';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  static final _allShipments = [
    const EliteShipmentData(
      id: '#BL-99283',
      date: '24 أكتوبر 2023',
      status: 'تم التسليم',
      customer: 'أحمد محمود الجوهري',
      location: 'الرياض، حي النرجس',
      count: 1,
      statusType: EliteShipmentStatus.delivered,
    ),
    const EliteShipmentData(
      id: '#BL-44821',
      date: '25 أكتوبر 2023',
      status: 'قيد التوصيل',
      customer: 'شركة الحلول الرقمية',
      location: 'جدة، طريق الملك',
      count: 3,
      statusType: EliteShipmentStatus.inTransit,
    ),
    const EliteShipmentData(
      id: '#BL-22019',
      date: '23 أكتوبر 2023',
      status: 'مرتجع',
      customer: 'سارة عبد العزيز',
      location: 'الدمام، الكورنيش',
      count: 1,
      statusType: EliteShipmentStatus.returned,
      errorReason: 'فشل الاستلام',
    ),
  ];

  static const _tabs = ['الكل', 'قيد التوصيل', 'تم التسليم', 'مرتجع'];

  List<EliteShipmentData> get _filtered {
    return _allShipments.where((s) {
      final matchesTab = _activeTab == 'الكل' || s.status == _activeTab;
      final q = _searchQuery.toLowerCase();
      final matchesSearch =
          q.isEmpty ||
          s.id.toLowerCase().contains(q) ||
          s.customer.toLowerCase().contains(q);
      return matchesTab && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surfaceContainer,
      appBar: const EliteTopBar(
        title: 'WaslShip - قائمة الشحنات',
        showMenu: true,
      ),
      body: Column(
        children: [
          Column(
            children: [
              const SizedBox(height: 12),
              // Tab chips
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemCount: _tabs.length,
                  itemBuilder: (context, i) {
                    final tab = _tabs[i];
                    final active = _activeTab == tab;
                    return GestureDetector(
                      onTap: () => setState(() => _activeTab = tab),
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
                          tab,
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
                  controller: _searchController,
                  textDirection: TextDirection.rtl,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'البحث برقم الشحنة أو اسم العميل...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: colors.surfaceContainerLow,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
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

          Expanded(
            child: _filtered.isEmpty
                ? EliteEmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: 'لا توجد شحنات',
                    description: _searchQuery.isNotEmpty
                        ? 'لم يتم العثور على نتائج تطابق بحثك.'
                        : 'لا يوجد لديك أي شحنات في هذه الفئة حالياً.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: _filtered.length,
                    itemBuilder: (context, i) => EliteShipmentCard(
                      shipment: _filtered[i],
                      onTrack: widget.onTrack,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
