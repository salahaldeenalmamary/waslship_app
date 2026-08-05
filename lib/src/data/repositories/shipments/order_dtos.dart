import 'package:json_annotation/json_annotation.dart';
import 'shipment_dtos.dart';

part 'order_dtos.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateOrderRequest {
  final String senderAddressId;
  final String recipientAddressId;
  final int deliveryOptionId;
  final double weight;
  final double shippingCost;
  final double? length;
  final double? width;
  final double? height;
  final double amount;
  final double codAmount;
  final String currency;
  final List<ShipmentItemDto> items;

  const CreateOrderRequest({
    required this.senderAddressId,
    required this.recipientAddressId,
    required this.deliveryOptionId,
    required this.weight,
    required this.shippingCost,
    this.length,
    this.width,
    this.height,
    required this.amount,
    required this.codAmount,
    required this.currency,
    required this.items,
  });

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateOrderRequestToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BulkCreateOrderItemRequest {
  final String senderAddressId;
  final String recipientAddressId;
  final double weight;
  final double shippingCost;
  final double amount;
  final double codAmount;
  final List<ShipmentItemDto> items;

  const BulkCreateOrderItemRequest({
    required this.senderAddressId,
    required this.recipientAddressId,
    required this.weight,
    required this.shippingCost,
    required this.amount,
    required this.codAmount,
    required this.items,
  });

  factory BulkCreateOrderItemRequest.fromJson(Map<String, dynamic> json) =>
      _$BulkCreateOrderItemRequestFromJson(json);
  Map<String, dynamic> toJson() => _$BulkCreateOrderItemRequestToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BulkCreateOrdersRequest {
  final List<BulkCreateOrderItemRequest> orders;

  const BulkCreateOrdersRequest({required this.orders});

  factory BulkCreateOrdersRequest.fromJson(Map<String, dynamic> json) =>
      _$BulkCreateOrdersRequestFromJson(json);
  Map<String, dynamic> toJson() => _$BulkCreateOrdersRequestToJson(this);
}

@JsonSerializable()
class OrderResultDto {
  final bool success;
  final String? shipmentId;
  final String? trackingNumber;
  final int? otoId;
  final String? error;

  const OrderResultDto({
    required this.success,
    this.shipmentId,
    this.trackingNumber,
    this.otoId,
    this.error,
  });

  factory OrderResultDto.fromJson(Map<String, dynamic> json) =>
      _$OrderResultDtoFromJson(json);
  Map<String, dynamic> toJson() => _$OrderResultDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BulkCreateOrdersResultDto {
  final List<OrderResultDto> results;

  const BulkCreateOrdersResultDto({required this.results});

  factory BulkCreateOrdersResultDto.fromJson(Map<String, dynamic> json) =>
      _$BulkCreateOrdersResultDtoFromJson(json);
  Map<String, dynamic> toJson() => _$BulkCreateOrdersResultDtoToJson(this);
}
