import 'package:json_annotation/json_annotation.dart';

part 'carrier_dtos.g.dart';

// ─── Verify Address ───────────────────────────────────────────────────────────

@JsonSerializable()
class VerifyAddressRequest {
  final String city;
  final String country;
  final String? district;

  const VerifyAddressRequest({
    required this.city,
    required this.country,
    this.district,
  });

  factory VerifyAddressRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyAddressRequestFromJson(json);
  Map<String, dynamic> toJson() => _$VerifyAddressRequestToJson(this);
}

@JsonSerializable()
class VerifyAddressResponse {
  final bool covered;
  final String city;
  final String? message;

  const VerifyAddressResponse({
    required this.covered,
    required this.city,
    this.message,
  });

  factory VerifyAddressResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyAddressResponseFromJson(json);
  Map<String, dynamic> toJson() => _$VerifyAddressResponseToJson(this);
}

// ─── Delivery Fee Details ─────────────────────────────────────────────────────

@JsonSerializable()
class DeliveryFeeDetailsRequest {
  final String orderId;

  const DeliveryFeeDetailsRequest({required this.orderId});

  factory DeliveryFeeDetailsRequest.fromJson(Map<String, dynamic> json) =>
      _$DeliveryFeeDetailsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$DeliveryFeeDetailsRequestToJson(this);
}

@JsonSerializable()
class DeliveryCompanyDto {
  final String? serviceType;
  final String? deliveryOptionName;
  final String? trackingType;
  final double? codCharge;
  final String? pickupCutOffTime;
  final double? maxOrderValue;
  final double? maxCODValue;
  final int? deliveryOptionId;
  final double? extraWeightPerKg;
  final String? deliveryCompanyName;
  final double? returnFee;
  final double? maxFreeWeight;
  final String? avgDeliveryTime;
  final double? price;
  final String? logo;
  final String? currency;
  final String? pickupDropoff;
  final String? cardOnDeliveryPercentage;

  const DeliveryCompanyDto({
    this.serviceType,
    this.deliveryOptionName,
    this.trackingType,
    this.codCharge,
    this.pickupCutOffTime,
    this.maxOrderValue,
    this.maxCODValue,
    this.deliveryOptionId,
    this.extraWeightPerKg,
    this.deliveryCompanyName,
    this.returnFee,
    this.maxFreeWeight,
    this.avgDeliveryTime,
    this.price,
    this.logo,
    this.currency,
    this.pickupDropoff,
    this.cardOnDeliveryPercentage,
  });

  factory DeliveryCompanyDto.fromJson(Map<String, dynamic> json) =>
      _$DeliveryCompanyDtoFromJson(json);
  Map<String, dynamic> toJson() => _$DeliveryCompanyDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DeliveryFeeDetailsResponse {
  final bool success;
  final List<DeliveryCompanyDto>? deliveryCompany;

  const DeliveryFeeDetailsResponse({
    required this.success,
    this.deliveryCompany,
  });

  factory DeliveryFeeDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$DeliveryFeeDetailsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DeliveryFeeDetailsResponseToJson(this);
}

// ─── Available Cities (POST) ──────────────────────────────────────────────────

@JsonSerializable()
class AvailableCitiesRequest {
  final String country;

  const AvailableCitiesRequest({required this.country});

  factory AvailableCitiesRequest.fromJson(Map<String, dynamic> json) =>
      _$AvailableCitiesRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AvailableCitiesRequestToJson(this);
}

@JsonSerializable()
class CityDto {
  final String name;

  const CityDto({required this.name});

  factory CityDto.fromJson(Map<String, dynamic> json) =>
      _$CityDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CityDtoToJson(this);
}


// ─── Get All Cities (GET, paginated) ─────────────────────────────────────────

@JsonSerializable(explicitToJson: true)
class GetCitiesPageDto {
  final int totalCount;
  final int perPage;
  @JsonKey(name: 'Cities')
  final List<CityDto>? cities;

  const GetCitiesPageDto({
    required this.totalCount,
    required this.perPage,
    this.cities,
  });

  factory GetCitiesPageDto.fromJson(Map<String, dynamic> json) =>
      _$GetCitiesPageDtoFromJson(json);
  Map<String, dynamic> toJson() => _$GetCitiesPageDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetCitiesResponse {
  final GetCitiesPageDto getCities;

  const GetCitiesResponse({required this.getCities});

  factory GetCitiesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetCitiesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetCitiesResponseToJson(this);
}
