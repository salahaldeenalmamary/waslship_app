import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/shipments/shipment_dtos.dart';
import '../../../data/repositories/shipments/shipment_repo.dart';
import 'shipments_providers.dart';
import 'shipments_state.dart';

class ShipmentsNotifier extends Notifier<ShipmentsState> {
  late final ShipmentRepo _repo;

  @override
  ShipmentsState build() {
    _repo = ref.read(shipmentRepoProvider);
    Future.microtask(() => loadShipments(refresh: true));
    return const ShipmentsState();
  }

  Future<void> loadShipments({bool refresh = false}) async {
    if (state.isLoadingMore) return;
    if (state.shipments.isLoading && !refresh) return;
    if (!refresh &&
        !state.hasNextPage &&
        (state.shipments.value?.isNotEmpty ?? false)) {
      return;
    }

    final page = refresh ? 1 : state.currentPage;

    if (refresh) {
      state = state.copyWith(shipments: const AsyncValue.loading());
    } else {
      state = state.copyWith(isLoadingMore: true);
    }

    final result = await _repo.searchShipments(
      status: state.activeStatus,
      trackingNumber: state.searchQuery.isNotEmpty ? state.searchQuery : null,
      page: page,
      pageSize: 20,
    );

    result.fold(
      onOk: (response) {
        final pageData = response.data;
        if (pageData == null) {
          state = state.copyWith(
            shipments: AsyncValue.data(state.shipments.value ?? []),
            isLoadingMore: false,
          );
          return;
        }

        final List<ShipmentDto> updated = refresh
            ? pageData.items.cast<ShipmentDto>()
            : [
                ...(state.shipments.value ?? []),
                ...pageData.items,
              ].cast<ShipmentDto>();

        state = state.copyWith(
          shipments: AsyncValue.data(updated),
          isLoadingMore: false,
          currentPage: pageData.pageNumber + 1,
          hasNextPage: pageData.hasNextPage,
        );
      },
      onErr: (message, _) {
        state = state.copyWith(
          shipments: AsyncValue.error(message, StackTrace.current),
          isLoadingMore: false,
        );
      },
    );
  }

  void setStatusFilter(String? status) {
    if (state.activeStatus == status) return;
    state = state.copyWith(activeStatus: status, clearStatus: status == null);
    loadShipments(refresh: true);
  }

  void setSearchQuery(String query) {
    if (state.searchQuery == query) return;
    state = state.copyWith(searchQuery: query);
    loadShipments(refresh: true);
  }

  Future<void> cancelShipment(String id) async {
    final result = await _repo.cancelShipment(id);
    result.fold(
      onOk: (_) => loadShipments(refresh: true),
      onErr: (message, _) {
        state = state.copyWith(
          shipments: AsyncValue.error(message, StackTrace.current),
        );
      },
    );
  }

  Future<void> refresh() => loadShipments(refresh: true);
}
