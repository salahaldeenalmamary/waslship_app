import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/shipments/shipment_dtos.dart';

class ShipmentsState {
  /// Main list — wraps loading / data / error in one field.
  final AsyncValue<List<ShipmentDto>> shipments;

  /// Separate flag for "load-more" so the existing list stays visible
  /// while the next page is fetching.
  final bool isLoadingMore;

  final int currentPage;
  final bool hasNextPage;
  final String? activeStatus; // null = all
  final String searchQuery;

  const ShipmentsState({
    this.shipments = const AsyncValue.loading(),
    this.isLoadingMore = false,
    this.currentPage = 1,
    this.hasNextPage = false,
    this.activeStatus,
    this.searchQuery = '',
  });

  ShipmentsState copyWith({
    AsyncValue<List<ShipmentDto>>? shipments,
    bool? isLoadingMore,
    int? currentPage,
    bool? hasNextPage,
    String? activeStatus,
    String? searchQuery,
    bool clearStatus = false,
  }) {
    return ShipmentsState(
      shipments: shipments ?? this.shipments,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      activeStatus: clearStatus ? null : (activeStatus ?? this.activeStatus),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<ShipmentDto> get items => shipments.value ?? [];
}
