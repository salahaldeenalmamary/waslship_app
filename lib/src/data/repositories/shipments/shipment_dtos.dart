import 'package:json_annotation/json_annotation.dart';

part 'shipment_dtos.g.dart';

@JsonSerializable(explicitToJson: true)
class ShipmentItemDto {
  final String name;
  final double price;
  final int quantity;
  final String? sku;

  const ShipmentItemDto({
    required this.name,
    required this.price,
    required this.quantity,
    this.sku,
  });

  factory ShipmentItemDto.fromJson(Map<String, dynamic> json) =>
      _$ShipmentItemDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ShipmentItemDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CreateShipmentRequest {
  final String senderAddressId;
  final String recipientAddressId;
  final String? orderId;
  final int deliveryOptionId;
  final double weight;
  final double shippingCost;
  final double amount;
  final double codAmount;
  final String currency;
  final List<ShipmentItemDto> items;

  const CreateShipmentRequest({
    required this.senderAddressId,
    required this.recipientAddressId,
    this.orderId,
    required this.deliveryOptionId,
    required this.weight,
    required this.shippingCost,
    required this.amount,
    required this.codAmount,
    required this.currency,
    required this.items,
  });

  factory CreateShipmentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateShipmentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateShipmentRequestToJson(this);
}

@JsonSerializable()
class UpdateShipmentRequest {
  final String? senderName;
  final String? senderPhone;
  final String? senderCity;
  final String? recipientName;
  final String? recipientPhone;
  final String? recipientCity;
  final String? recipientAddress;
  final String? recipientDistrict;
  final String? recipientEmail;
  final double? weight;
  final double? amount;
  final double? codAmount;

  const UpdateShipmentRequest({
    this.senderName,
    this.senderPhone,
    this.senderCity,
    this.recipientName,
    this.recipientPhone,
    this.recipientCity,
    this.recipientAddress,
    this.recipientDistrict,
    this.recipientEmail,
    this.weight,
    this.amount,
    this.codAmount,
  });

  factory UpdateShipmentRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateShipmentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateShipmentRequestToJson(this);
}

@JsonSerializable()
class UpdateShipmentStatusRequest {
  final String status;
  final String? note;
  final String? reason;

  const UpdateShipmentStatusRequest({
    required this.status,
    this.note,
    this.reason,
  });

  factory UpdateShipmentStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateShipmentStatusRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateShipmentStatusRequestToJson(this);
}

@JsonSerializable()
class ShipmentDto {
  final String id;
  final String trackingNumber;
  final int? otoId;
  final String? carrierTrackingNumber;
  final String? carrierName;
  final String status;
  final String senderCity;
  final String recipientName;
  final String recipientCity;
  final double weight;
  final double shippingCost;
  final double codAmount;
  final String? labelUrl;
  final String? createdAt;

  const ShipmentDto({
    required this.id,
    required this.trackingNumber,
    this.otoId,
    required this.carrierTrackingNumber,
    required this.carrierName,
    required this.status,
    required this.senderCity,
    required this.recipientName,
    required this.recipientCity,
    required this.weight,
    required this.shippingCost,
    required this.codAmount,
    this.labelUrl,
    required this.createdAt,
  });

  factory ShipmentDto.fromJson(Map<String, dynamic> json) =>
      _$ShipmentDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ShipmentDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ShipmentDetailsDto {
  final ShipmentDto local;
  final Map<String, dynamic>? oto;

  const ShipmentDetailsDto({required this.local, this.oto});

  factory ShipmentDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$ShipmentDetailsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ShipmentDetailsDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ShipmentsSearchPageDto {
  final List<ShipmentDto> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const ShipmentsSearchPageDto({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory ShipmentsSearchPageDto.fromJson(Map<String, dynamic> json) =>
      _$ShipmentsSearchPageDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ShipmentsSearchPageDtoToJson(this);
}
