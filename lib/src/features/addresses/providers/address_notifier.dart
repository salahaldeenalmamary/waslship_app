import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/network/network.dart';
import '../../../data/repositories/address/address_repo.dart';
import '../../../data/repositories/address/models/address_dtos.dart';
import '../../../data/repositories/auth/models/auth_dtos.dart';
import 'address_state.dart';

class AddressNotifier extends StateNotifier<AddressState> {
  final AddressRepo _addressRepo;

  AddressNotifier(this._addressRepo) : super(const AddressState());

  Future<void> loadAddresses() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _addressRepo.getUserAddresses();

    result.fold(
      onOk: (response) {
        state = state.copyWith(isLoading: false, addresses: response.addresses);
      },
      onErr: (message, _) {
        state = state.copyWith(isLoading: false, errorMessage: message);
      },
    );
  }

  Future<Result<AddressResponseDto>> addAddress(
    AddAddressRequestDto request,
  ) async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    final result = await _addressRepo.addUserAddress(request);

    result.fold(
      onOk: (response) {
        final newAddress = response;
        if (newAddress != null) {
          state = state.copyWith(
            isSaving: false,
            addresses: [...state.addresses, newAddress],
            successMessage: 'تمت إضافة العنوان بنجاح',
          );
        }
      },
      onErr: (message, _) {
        state = state.copyWith(isSaving: false, errorMessage: message);
      },
    );

    return result;
  }

  Future<Result<AddressResponseDto>> updateAddress(
    int addressId,
    UpdateAddressRequestDto request,
  ) async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    final result = await _addressRepo.updateUserAddress(addressId, request);

    result.fold(
      onOk: (response) {
        final updatedAddress = response;
        if (updatedAddress != null) {
          final updatedList = state.addresses.map((addr) {
            return addr.id == addressId ? updatedAddress : addr;
          }).toList();

          state = state.copyWith(
            isSaving: false,
            addresses: updatedList,
            successMessage: 'تم تحديث العنوان بنجاح',
          );
        }
      },
      onErr: (message, _) {
        state = state.copyWith(isSaving: false, errorMessage: message);
      },
    );

    return result;
  }

  Future<Result<MessageResponseDto>> deleteAddress(int addressId) async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    final result = await _addressRepo.deleteUserAddress(addressId);

    result.fold(
      onOk: (_) {
        state = state.copyWith(
          isSaving: false,
          addresses: state.addresses
              .where((addr) => addr.id != addressId)
              .toList(),
          successMessage: 'تم حذف العنوان بنجاح',
        );
      },
      onErr: (message, _) {
        state = state.copyWith(isSaving: false, errorMessage: message);
      },
    );

    return result;
  }

  Future<Result<AddressResponseDto>> setDefaultAddress(int addressId) async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    final result = await _addressRepo.setDefaultUserAddress(addressId);

    result.fold(
      onOk: (response) {
        final updatedList = state.addresses.map((addr) {
          return addr.copyWith(isDefault: addr.id == addressId);
        }).toList();

        state = state.copyWith(
          isSaving: false,
          addresses: updatedList,
          successMessage: 'تم تعيين العنوان كافتراضي',
        );
      },
      onErr: (message, _) {
        state = state.copyWith(isSaving: false, errorMessage: message);
      },
    );

    return result;
  }

  void selectAddress(AddressResponseDto? address) {
    state = state.copyWith(selectedAddress: address);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void clearSuccessMessage() {
    state = state.copyWith(successMessage: null);
  }

  void resetState() {
    state = const AddressState();
  }
}
