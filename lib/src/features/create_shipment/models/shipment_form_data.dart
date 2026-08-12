import 'package:freezed_annotation/freezed_annotation.dart';

part 'shipment_form_data.freezed.dart';
part 'shipment_form_data.g.dart';

@freezed
sealed class PackageDetails with _$PackageDetails {
  const factory PackageDetails({
    @Default('') String contentType,
    @Default('2.5') String weight,
    @Default('30') String length,
    @Default('20') String width,
    @Default('15') String height,
    @Default('32.00') String shippingCost,
  }) = _PackageDetails;

  factory PackageDetails.fromJson(Map<String, dynamic> json) =>
      _$PackageDetailsFromJson(json);
}

@freezed
sealed class PaymentDetails with _$PaymentDetails {
  const factory PaymentDetails({
    @Default('150.00') String orderAmount,
    @Default('0') String codAmount,
  }) = _PaymentDetails;

  factory PaymentDetails.fromJson(Map<String, dynamic> json) =>
      _$PaymentDetailsFromJson(json);
}

@freezed
sealed class ShipmentFormData with _$ShipmentFormData {
  const factory ShipmentFormData({
    required PackageDetails package,
    required PaymentDetails payment,
  }) = _ShipmentFormData;

  factory ShipmentFormData.fromJson(Map<String, dynamic> json) =>
      _$ShipmentFormDataFromJson(json);
}
