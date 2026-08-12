import '../../../app/providers/dio_provider.dart';
import '../../../data/repositories/address/address_repo.dart';
import '../../../data/repositories/carrier/carrier_repo.dart';
import '../../../data/repositories/shipments/shipment_repo.dart';
import '../../../imports/imports.dart';
import 'create_shipment_notifier.dart';
import 'create_shipment_state.dart';

// ─── Repo Providers ───────────────────────────────────────────────────────────

final createShipmentRepoProvider = Provider.autoDispose<ShipmentRepo>((ref) {
  final dio = ref.watch(dioProvider);
  return ShipmentRepo(dio);
});

final createCarrierRepoProvider = Provider.autoDispose<CarrierRepo>((ref) {
  final dio = ref.watch(dioProvider);
  return CarrierRepo(dio);
});

final createAddressRepoProvider = Provider.autoDispose<AddressRepo>((ref) {
  final dio = ref.watch(dioProvider);
  return AddressRepo(dio);
});

// ─── Main Provider ────────────────────────────────────────────────────────────

final createShipmentProvider =
    NotifierProvider.autoDispose<CreateShipmentNotifier, CreateShipmentState>(
      () => CreateShipmentNotifier(),
    );
