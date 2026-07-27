// File: lib/features/address/data/dto/address_dtos.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address_dtos.freezed.dart';
part 'address_dtos.g.dart';

// ============================================
// Request DTOs
// ============================================

@JsonSerializable()
class AddAddressRequestDto {
  final String label;
  final String fullName;
  final String phone;
  final String street;
  final String city;
  final String district;
  final String? buildingNumber;
  final String? apartmentNumber;
  final String? floorNumber;
  final String? additionalDirections;
  final String? postalCode;
  final double? latitude;
  final double? longitude;
  final bool? isDefault;

  const AddAddressRequestDto({
    required this.label,
    required this.fullName,
    required this.phone,
    required this.street,
    required this.city,
    required this.district,
    this.buildingNumber,
    this.apartmentNumber,
    this.floorNumber,
    this.additionalDirections,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.isDefault,
  });

  factory AddAddressRequestDto.fromJson(Map<String, dynamic> json) =>
      _$AddAddressRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddAddressRequestDtoToJson(this);
}

@JsonSerializable()
class UpdateAddressRequestDto {
  final String? label;
  final String? fullName;
  final String? phone;
  final String? street;
  final String? city;
  final String? district;
  final String? buildingNumber;
  final String? apartmentNumber;
  final String? floorNumber;
  final String? additionalDirections;
  final String? postalCode;
  final double? latitude;
  final double? longitude;
  final bool? isDefault;

  const UpdateAddressRequestDto({
    this.label,
    this.fullName,
    this.phone,
    this.street,
    this.city,
    this.district,
    this.buildingNumber,
    this.apartmentNumber,
    this.floorNumber,
    this.additionalDirections,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.isDefault,
  });

  factory UpdateAddressRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateAddressRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateAddressRequestDtoToJson(this);
}

@JsonSerializable()
class SetDefaultAddressRequestDto {
  final bool isDefault;

  const SetDefaultAddressRequestDto({required this.isDefault});

  factory SetDefaultAddressRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SetDefaultAddressRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SetDefaultAddressRequestDtoToJson(this);
}

// ============================================
// Response DTOs with Freezed
// ============================================

@freezed
sealed class AddressResponseDto with _$AddressResponseDto {
  const factory AddressResponseDto({
    required int id,
    required int userId,
    required String label,
    required String fullName,
    required String phone,
    required String street,
    required String city,
    required String district,
    String? buildingNumber,
    String? apartmentNumber,
    String? floorNumber,
    String? additionalDirections,
    String? postalCode,
    double? latitude,
    double? longitude,
    @Default(false) bool isDefault,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AddressResponseDto;

  factory AddressResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AddressResponseDtoFromJson(json);

  // Additional methods and getters
  const AddressResponseDto._();

  /// Get full address as formatted string
  String get formattedAddress {
    final parts = <String>[
      if (buildingNumber != null) 'Building $buildingNumber',
      if (apartmentNumber != null) 'Apt $apartmentNumber',
      if (floorNumber != null) 'Floor $floorNumber',
      street,
      district,
      city,
      if (additionalDirections != null) additionalDirections!,
    ];
    return parts.join(', ');
  }

  /// Get short address display
  String get shortAddress => '$district, $city';
}

@Freezed()
sealed class AddressListResponseDto with _$AddressListResponseDto {
  const factory AddressListResponseDto({
    required List<AddressResponseDto> addresses,
  }) = _AddressListResponseDto;

  factory AddressListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AddressListResponseDtoFromJson(json);

  const AddressListResponseDto._();

  /// Get default address if any
  AddressResponseDto? get defaultAddress {
    try {
      return addresses.firstWhere((addr) => addr.isDefault);
    } catch (_) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  /// Get addresses filtered by city
  List<AddressResponseDto> getByCity(String city) {
    return addresses.where((addr) => addr.city == city).toList();
  }

  /// Check if there are any addresses
  bool get hasAddresses => addresses.isNotEmpty;
}
