import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/repositories/address/models/address_dtos.dart';

part 'address_state.freezed.dart';

@freezed
sealed class AddressState with _$AddressState {
  const factory AddressState({
    @Default([]) List<AddressResponseDto> addresses,
    @Default(false) bool isLoading,
    @Default(false) bool isSaving,
    AddressResponseDto? selectedAddress,
    String? errorMessage,
    String? successMessage,
  }) = _AddressState;

  const AddressState._();

  AddressResponseDto? get defaultAddress {
    try {
      return addresses.firstWhere((addr) => addr.isDefault);
    } catch (_) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  bool get hasAddresses => addresses.isNotEmpty;
  int get addressCount => addresses.length;
}
