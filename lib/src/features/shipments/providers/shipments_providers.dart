import '../../../app/providers/dio_provider.dart';
import '../../../data/repositories/carrier/carrier_repo.dart';
import '../../../data/repositories/shipments/shipment_repo.dart';
import '../../../imports/imports.dart';
import 'shipments_notifier.dart';
import 'shipments_state.dart';

final shipmentRepoProvider = Provider<ShipmentRepo>((ref) {
  final dio = ref.watch(dioProvider);
  return ShipmentRepo(dio);
});

final carrierRepoProvider = Provider<CarrierRepo>((ref) {
  final dio = ref.watch(dioProvider);
  return CarrierRepo(dio);
});

final shipmentsNotifierProvider =
    NotifierProvider.autoDispose<ShipmentsNotifier, ShipmentsState>(
      () => ShipmentsNotifier(),
    );
