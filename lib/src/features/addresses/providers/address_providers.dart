
import '../../../app/providers/dio_provider.dart';
import '../../../data/repositories/address/address_repo.dart';
import '../../../imports/imports.dart';
import 'address_notifier.dart';
import 'address_state.dart';

// AddressRepo provider
final addressRepoProvider = Provider<AddressRepo>((ref) {
  final dio = ref.watch(dioProvider);
  return AddressRepo(dio);
});

// AddressNotifier provider
final addressNotifierProvider =
    StateNotifierProvider<AddressNotifier, AddressState>((ref) {
      final addressRepo = ref.watch(addressRepoProvider);
      return AddressNotifier(addressRepo);
    });
