import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/repositories/address/models/address_dtos.dart';
import '../models/carrier.dart';
import '../models/shipment_form_data.dart';

part 'create_shipment_state.freezed.dart';

@freezed
sealed class CreateShipmentState with _$CreateShipmentState {
  const factory CreateShipmentState({
    @Default(1) int currentStep,
    required ShipmentFormData formData,
    @Default({}) Map<String, String> errors,
    @Default(false) bool hasExistingDraft,
    @Default(false) bool showSuccessToast,
    @Default(false) bool smartRecommend,
    String? selectedCarrierId,

    // ── Addresses ─────────────────────────────────────────────────────────────
    @Default(AsyncValue<List<AddressResponseDto>>.loading())
    AsyncValue<List<AddressResponseDto>> addresses,
    AddressResponseDto? senderAddress,
    AddressResponseDto? recipientAddress,

    // ── Cities ────────────────────────────────────────────────────────────────
    @Default(AsyncValue<List<String>>.loading())
    AsyncValue<List<String>> cities,

    // ── Carriers ──────────────────────────────────────────────────────────────
    @Default(AsyncValue<List<Carrier>>.data([]))
    AsyncValue<List<Carrier>> carriers,

    // ── Order/Submission ──────────────────────────────────────────────────────
    String? createdOrderId,
    @Default(AsyncValue<void>.data(null)) AsyncValue<void> submission,
  }) = _CreateShipmentState;

  const CreateShipmentState._();

  Carrier? get selectedCarrier {
    if (selectedCarrierId == null) return null;
    final list = carriers.value ?? [];
    for (final c in list) {
      if (c.id == selectedCarrierId) return c;
    }
    return null;
  }
}
