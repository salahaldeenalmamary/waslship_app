import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/shipments/shipment_dtos.dart';

class ShipmentsState {
  final bool isLoadingMore;
  final AsyncValue<List<ShipmentDto>> shipments;
  final int currentPage;
  final bool hasNextPage;

  final String? activeStatus;
  final String searchQuery;

  const ShipmentsState({
    this.isLoadingMore = false,
    this.shipments = const AsyncValue.loading(),
    this.currentPage = 1,
    this.hasNextPage = false,

    this.activeStatus,
    this.searchQuery = '',
  });

  ShipmentsState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    AsyncValue<List<ShipmentDto>>? shipments,
    int? currentPage,
    bool? hasNextPage,
    String? errorMessage,
    String? activeStatus,
    String? searchQuery,
    bool clearError = false,
    bool clearStatus = false,
  }) {
    return ShipmentsState(
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      shipments: shipments ?? this.shipments,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,

      activeStatus: clearStatus ? null : (activeStatus ?? this.activeStatus),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
