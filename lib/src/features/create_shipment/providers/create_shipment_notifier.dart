import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/address/models/address_dtos.dart';
import '../../../data/repositories/carrier/carrier_dtos.dart';
import '../../../data/repositories/shipments/order_dtos.dart';
import '../models/carrier.dart';
import '../models/shipment_form_data.dart';
import 'create_shipment_providers.dart';
import 'create_shipment_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _draftStorageKey = 'waslship_draft_shipment';

class CreateShipmentNotifier extends Notifier<CreateShipmentState> {
  @override
  CreateShipmentState build() {
    _init();
    return const CreateShipmentState(
      formData: ShipmentFormData(
        package: PackageDetails(),
        payment: PaymentDetails(),
      ),
    );
  }

  void _init() {
    _loadAddresses();
    _loadCities();
    _checkForDraft();
  }

  // ─── Addresses ─────────────────────────────────────────────────────────────

  Future<void> _loadAddresses() async {
    state = state.copyWith(
      addresses: const AsyncValue<List<AddressResponseDto>>.loading(),
    );
    final result = await ref.read(createAddressRepoProvider).getUserAddresses();

    result.fold(
      onOk: (response) {
        final list = response.data?.addresses ?? [];
        final defaultAddr = list.firstWhere(
          (a) => a.isDefault,
          orElse: () => list.isNotEmpty ? list.first : throw StateError(''),
        );
        state = state.copyWith(
          addresses: AsyncValue.data(list),
          senderAddress: list.isNotEmpty ? defaultAddr : null,
        );
      },
      onErr: (message, cause) {
        state = state.copyWith(
          addresses: AsyncValue.error(message, StackTrace.current),
        );
      },
    );
  }

  void selectSenderAddress(AddressResponseDto address) {
    state = state.copyWith(senderAddress: address);
  }

  void selectRecipientAddress(AddressResponseDto address) {
    state = state.copyWith(recipientAddress: address);
  }

  // ─── Cities ────────────────────────────────────────────────────────────────

  Future<void> _loadCities() async {
    state = state.copyWith(cities: const AsyncValue<List<String>>.loading());
    final result = await ref.read(createCarrierRepoProvider).getAllCities();

    result.fold(
      onOk: (response) {
        final names = (response.getCities.cities ?? [])
            .map((c) => c.name)
            .toList();
        state = state.copyWith(cities: AsyncValue.data(names));
      },
      onErr: (message, _) {
        state = state.copyWith(
          cities: AsyncValue.error(message, StackTrace.current),
        );
      },
    );
  }

  // ─── Package Field Updates ─────────────────────────────────────────────────

  void updateContentType(String value) {
    state = state.copyWith(
      formData: state.formData.copyWith(
        package: state.formData.package.copyWith(contentType: value),
      ),
      errors: {...state.errors}..remove('contentType'),
    );
  }

  void updateWeight(String value) {
    state = state.copyWith(
      formData: state.formData.copyWith(
        package: state.formData.package.copyWith(weight: value),
      ),
      errors: {...state.errors}..remove('weight'),
    );
  }

  void updateLength(String value) {
    state = state.copyWith(
      formData: state.formData.copyWith(
        package: state.formData.package.copyWith(length: value),
      ),
      errors: {...state.errors}..remove('length'),
    );
  }

  void updateWidth(String value) {
    state = state.copyWith(
      formData: state.formData.copyWith(
        package: state.formData.package.copyWith(width: value),
      ),
      errors: {...state.errors}..remove('width'),
    );
  }

  void updateHeight(String value) {
    state = state.copyWith(
      formData: state.formData.copyWith(
        package: state.formData.package.copyWith(height: value),
      ),
      errors: {...state.errors}..remove('height'),
    );
  }

  void updateShippingCost(String value) {
    state = state.copyWith(
      formData: state.formData.copyWith(
        package: state.formData.package.copyWith(shippingCost: value),
      ),
      errors: {...state.errors}..remove('shippingCost'),
    );
  }

  // ─── Payment Field Updates ─────────────────────────────────────────────────

  void updateOrderAmount(String value) {
    state = state.copyWith(
      formData: state.formData.copyWith(
        payment: state.formData.payment.copyWith(orderAmount: value),
      ),
      errors: {...state.errors}..remove('amount'),
    );
  }

  void updateCodAmount(String value) {
    state = state.copyWith(
      formData: state.formData.copyWith(
        payment: state.formData.payment.copyWith(codAmount: value),
      ),
      errors: {...state.errors}..remove('codAmount'),
    );
  }

  // ─── Carrier Selection ─────────────────────────────────────────────────────

  void selectCarrier(String carrierId) {
    final list = state.carriers.value ?? [];
    final carrier = list.where((c) => c.id == carrierId).firstOrNull;
    if (carrier != null) {
      state = state.copyWith(
        formData: state.formData.copyWith(
          package: state.formData.package.copyWith(shippingCost: carrier.price),
        ),
        selectedCarrierId: carrierId,
      );
    }
  }

  void toggleSmartRecommend() {
    final newValue = !state.smartRecommend;
    state = state.copyWith(smartRecommend: newValue);
    if (newValue) {
      final list = state.carriers.value ?? [];
      final recommended = list.where((c) => c.isRecommended).firstOrNull;
      if (recommended != null) selectCarrier(recommended.id);
    }
  }

  // ─── Validation ────────────────────────────────────────────────────────────

  bool validateStep1() {
    final Map<String, String> newErrors = {};
    final data = state.formData;

    if (state.senderAddress == null) {
      newErrors['senderAddress'] = 'يرجى اختيار عنوان المرسل';
    }
    if (state.recipientAddress == null) {
      newErrors['recipientAddress'] = 'يرجى اختيار عنوان المستلم';
    }
    if (data.package.contentType.trim().isEmpty) {
      newErrors['contentType'] = 'يرجى تحديد نوع المحتوى';
    }

    final weight = double.tryParse(data.package.weight);
    if (weight == null || weight <= 0) {
      newErrors['weight'] = 'أدخل وزناً صحيحاً أكبر من 0 كجم';
    }

    final length = double.tryParse(data.package.length);
    if (length == null || length <= 0) {
      newErrors['length'] = 'أدخل طولاً صحيحاً أكبر من 0 سم';
    }

    final width = double.tryParse(data.package.width);
    if (width == null || width <= 0) {
      newErrors['width'] = 'أدخل عرضاً صحيحاً أكبر من 0 سم';
    }

    final height = double.tryParse(data.package.height);
    if (height == null || height <= 0) {
      newErrors['height'] = 'أدخل ارتفاعاً صحيحاً أكبر من 0 سم';
    }

    final amount = double.tryParse(data.payment.orderAmount);
    if (amount == null || amount < 0) {
      newErrors['amount'] = 'أدخل إجمالي قيمة الطلب';
    }

    final codAmount = double.tryParse(data.payment.codAmount);
    if (codAmount == null || codAmount < 0) {
      newErrors['codAmount'] =
          'أدخل مبلغ التحصيل بشكل صحيح (ضع 0 للمدفوع مسبقاً)';
    }

    state = state.copyWith(errors: newErrors);
    return newErrors.isEmpty;
  }

  // ─── Step Navigation ───────────────────────────────────────────────────────

  /// Step 1 → 2: validate, create order on OTO, then fetch carrier options.
  Future<void> nextStep() async {
    if (state.currentStep == 1) {
      if (!validateStep1()) return;
      await _createOrderAndLoadCarriers();
    } else if (state.currentStep == 2) {
      state = state.copyWith(currentStep: 3);
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void goToStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  // ─── API Calls ─────────────────────────────────────────────────────────────

  /// Creates an OTO order then fetches delivery fee/carrier options.
  Future<void> _createOrderAndLoadCarriers() async {
    state = state.copyWith(
      carriers: const AsyncValue<List<Carrier>>.loading(),
      submission: const AsyncValue<void>.loading(),
    );

    final data = state.formData;
    final senderAddress = state.senderAddress;
    final recipientAddress = state.recipientAddress;

    if (senderAddress == null || recipientAddress == null) {
      state = state.copyWith(
        submission: AsyncValue.error(
          'يرجى اختيار عناوين المرسل والمستلم',
          StackTrace.current,
        ),
        carriers: const AsyncValue.data([]),
      );
      return;
    }

    // Step A: Create order to get an orderId
    final orderResult = await ref
        .read(createShipmentRepoProvider)
        .createOrder(
          CreateOrderRequest(
            senderAddressId: senderAddress.id.toString(),
            recipientAddressId: recipientAddress.id.toString(),
            // Placeholder deliveryOptionId=0; real one is chosen in step 2.
            deliveryOptionId: 0,
            weight: double.tryParse(data.package.weight) ?? 0,
            shippingCost: double.tryParse(data.package.shippingCost) ?? 0,
            length: double.tryParse(data.package.length),
            width: double.tryParse(data.package.width),
            height: double.tryParse(data.package.height),
            amount: double.tryParse(data.payment.orderAmount) ?? 0,
            codAmount: double.tryParse(data.payment.codAmount) ?? 0,
            currency: 'SAR',
            itemDescription: data.package.contentType,
          ),
        );

    String? orderId;
    orderResult.fold(
      onOk: (response) {
        orderId = response.data?.shipmentId;
        state = state.copyWith(
          createdOrderId: orderId,
          submission: const AsyncValue<void>.data(null),
        );
      },
      onErr: (message, _) {
        state = state.copyWith(
          submission: AsyncValue.error(message, StackTrace.current),
          carriers: const AsyncValue.data([]),
        );
        return;
      },
    );

    if (orderId == null) return;

    // Step B: Fetch delivery options for this order
    final feeResult = await ref
        .read(createCarrierRepoProvider)
        .getDeliveryFeeDetails(DeliveryFeeDetailsRequest(orderId: orderId!));

    feeResult.fold(
      onOk: (response) {
        final mapped = _mapDtoToCarriers(response.deliveryCompany ?? []);
        state = state.copyWith(
          carriers: AsyncValue.data(mapped),
          currentStep: 2,
          // Pre-select first carrier if available
          selectedCarrierId: mapped.isNotEmpty ? mapped.first.id : null,
        );
      },
      onErr: (message, _) {
        state = state.copyWith(
          carriers: AsyncValue.error(message, StackTrace.current),
        );
      },
    );
  }

  /// Maps API [DeliveryCompanyDto] list → [Carrier] list.
  List<Carrier> _mapDtoToCarriers(List<DeliveryCompanyDto> dtos) {
    return dtos.map((dto) {
      final name =
          dto.deliveryCompanyName ?? dto.deliveryOptionName ?? 'شركة شحن';
      final price = (dto.price ?? 0).toStringAsFixed(2);
      final avgTime = dto.avgDeliveryTime ?? '';

      return Carrier(
        id: '${dto.deliveryOptionId ?? name}',
        name: name,
        logoAsset: 'assets/images/carriers/generic.png',
        logoUrl: dto.logo,
        estimatedTime: avgTime.isNotEmpty ? avgTime : 'خلال يومي عمل',
        price: price,
        paymentType: dto.codCharge != null && (dto.codCharge ?? 0) > 0
            ? 'الدفع عند الاستلام'
            : 'مدفوع',
        badge: dto.serviceType ?? 'موثوق',
        badgeType: CarrierBadgeType.trusted,
        isRecommended: false,
        deliveryOptionId: dto.deliveryOptionId,
      );
    }).toList();
  }

  // ─── Submit Shipment (Step 3) ──────────────────────────────────────────────

  Future<void> submitShipment() async {
    final orderId = state.createdOrderId;
    final carrier = state.selectedCarrier;

    if (orderId == null ||
        carrier == null ||
        carrier.deliveryOptionId == null) {
      state = state.copyWith(
        submission: AsyncValue.error(
          'يرجى اختيار شركة الشحن أولاً',
          StackTrace.current,
        ),
      );
      return;
    }

    state = state.copyWith(submission: const AsyncValue<void>.loading());

    final result = await ref
        .read(createShipmentRepoProvider)
        .createShipment(
          TriggerShipmentRequest(
            orderId: orderId,
            deliveryOptionId: carrier.deliveryOptionId!.toString(),
          ),
        );

    result.fold(
      onOk: (_) {
        clearDraft();
        state = state.copyWith(
          submission: const AsyncValue<void>.data(null),
          showSuccessToast: true,
        );
        Future.delayed(const Duration(seconds: 3), () {
          try {
            state = state.copyWith(showSuccessToast: false);
          } catch (_) {}
        });
      },
      onErr: (message, _) {
        state = state.copyWith(
          submission: AsyncValue.error(message, StackTrace.current),
        );
      },
    );
  }

  // ─── Draft ─────────────────────────────────────────────────────────────────

  void _checkForDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftJson = prefs.getString(_draftStorageKey);
      if (draftJson != null) {
        state = state.copyWith(hasExistingDraft: true);
      }
    } catch (_) {}
  }

  Future<void> saveDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftData = {
        ...state.formData.toJson(),
        'selectedCarrierId': state.selectedCarrierId,
        'step': state.currentStep,
        'savedAt': DateTime.now().toIso8601String(),
      };
      await prefs.setString(_draftStorageKey, jsonEncode(draftData));
      state = state.copyWith(hasExistingDraft: false, showSuccessToast: true);
      Future.delayed(const Duration(seconds: 3), () {
        try {
          state = state.copyWith(showSuccessToast: false);
        } catch (_) {}
      });
    } catch (_) {}
  }

  Future<void> restoreDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftJson = prefs.getString(_draftStorageKey);
      if (draftJson != null) {
        final data = jsonDecode(draftJson) as Map<String, dynamic>;
        final formData = ShipmentFormData.fromJson(data);
        final carrierId = data['selectedCarrierId'] as String?;
        final step = data['step'] as int? ?? 1;

        state = state.copyWith(
          formData: formData,
          selectedCarrierId: carrierId,
          currentStep: step,
          hasExistingDraft: false,
          showSuccessToast: true,
        );

        Future.delayed(const Duration(seconds: 3), () {
          try {
            state = state.copyWith(showSuccessToast: false);
          } catch (_) {}
        });
      }
    } catch (_) {}
  }

  Future<void> clearDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_draftStorageKey);
      state = state.copyWith(hasExistingDraft: false);
    } catch (_) {}
  }
}
