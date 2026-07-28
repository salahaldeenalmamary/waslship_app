import 'package:json_annotation/json_annotation.dart';

part 'payment_dtos.g.dart';

// ============================================
// Request DTOs
// ============================================

@JsonSerializable()
class InitiatePaymentRequestDto {
  @JsonKey(name: 'initiationRequest')
  final InitiationRequestDto initiationRequest;
  final String currency;

  const InitiatePaymentRequestDto({
    required this.initiationRequest,
    required this.currency,
  });

  factory InitiatePaymentRequestDto.fromJson(Map<String, dynamic> json) =>
      _$InitiatePaymentRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$InitiatePaymentRequestDtoToJson(this);
}

@JsonSerializable()
class InitiationRequestDto {
  final double amount;
  final String currency;

  const InitiationRequestDto({required this.amount, required this.currency});

  factory InitiationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$InitiationRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$InitiationRequestDtoToJson(this);
}

@JsonSerializable()
class ExecutePaymentRequestDto {
  @JsonKey(name: 'deposit_id')
  final String depositId;
  @JsonKey(name: 'payment_method_id')
  final String paymentMethodId;

  const ExecutePaymentRequestDto({
    required this.depositId,
    required this.paymentMethodId,
  });

  factory ExecutePaymentRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ExecutePaymentRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ExecutePaymentRequestDtoToJson(this);
}

@JsonSerializable()
class VerifyPaymentRequestDto {
  @JsonKey(name: 'deposit_id')
  final String depositId;

  const VerifyPaymentRequestDto({required this.depositId});

  factory VerifyPaymentRequestDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyPaymentRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyPaymentRequestDtoToJson(this);
}

// ============================================
// Response DTOs
// ============================================

@JsonSerializable()
class InitiatePaymentResponseDto {
  @JsonKey(name: 'depositId')
  final String depositId;
  @JsonKey(name: 'initiatePaymentResult')
  final InitiatePaymentResultDto initiatePaymentResult;
  @JsonKey(name: 'paymentId')
  final String? paymentId;

  const InitiatePaymentResponseDto({
    required this.depositId,
    required this.initiatePaymentResult,
    this.paymentId,
  });

  factory InitiatePaymentResponseDto.fromJson(Map<String, dynamic> json) =>
      _$InitiatePaymentResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$InitiatePaymentResponseDtoToJson(this);
}

@JsonSerializable()
class InitiatePaymentResultDto {
  @JsonKey(name: 'isSuccess')
  final bool isSuccess;
  final String? message;
  @JsonKey(name: 'availableMethods')
  final List<PaymentMethodDto> availableMethods;
  @JsonKey(name: 'serviceCharge')
  final double? serviceCharge;
  @JsonKey(name: 'totalAmount')
  final double? totalAmount;
  final String? currency;

  const InitiatePaymentResultDto({
    required this.isSuccess,
    this.message,
    required this.availableMethods,
    this.serviceCharge,
    this.totalAmount,
    this.currency,
  });

  factory InitiatePaymentResultDto.fromJson(Map<String, dynamic> json) =>
      _$InitiatePaymentResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$InitiatePaymentResultDtoToJson(this);
}

@JsonSerializable()
class PaymentMethodDto {
  final String id;
  final String name;
  @JsonKey(name: 'nameAr')
  final String nameAr;
  final String code;
  @JsonKey(name: 'imageUrl')
  final String imageUrl;
  @JsonKey(name: 'isDirectPayment')
  final bool isDirectPayment;
  @JsonKey(name: 'serviceCharge')
  final double serviceCharge;
  @JsonKey(name: 'totalAmount')
  final double totalAmount;

  const PaymentMethodDto({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.code,
    required this.imageUrl,
    required this.isDirectPayment,
    required this.serviceCharge,
    required this.totalAmount,
  });

  factory PaymentMethodDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodDtoToJson(this);

  /// Formatted price with service charge
  String get formattedTotal =>
      '${totalAmount.toStringAsFixed(3)} ${currencyCode()}';

  String currencyCode() => 'KWD';
}

@JsonSerializable()
class ExecutePaymentResponseDto {
  @JsonKey(name: 'paymentId')
  final String paymentId;
  @JsonKey(name: 'executePaymentResult')
  final ExecutePaymentResultDto executePaymentResult;

  const ExecutePaymentResponseDto({
    required this.paymentId,
    required this.executePaymentResult,
  });

  factory ExecutePaymentResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ExecutePaymentResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ExecutePaymentResponseDtoToJson(this);

  bool get isSuccess => executePaymentResult.isSuccess;
  String? get paymentUrl => executePaymentResult.paymentUrl;
  String? get transactionId => executePaymentResult.transactionId;
  String? get invoiceId => executePaymentResult.invoiceId;
  bool get hasPaymentUrl => paymentUrl != null && paymentUrl!.isNotEmpty;
}

@JsonSerializable()
class ExecutePaymentResultDto {
  @JsonKey(name: 'isSuccess')
  final bool isSuccess;
  final String? message;
  @JsonKey(name: 'paymentUrl')
  final String? paymentUrl;
  @JsonKey(name: 'transactionId')
  final String? transactionId;
  @JsonKey(name: 'invoiceId')
  final String? invoiceId;
  @JsonKey(name: 'paymentId')
  final String? paymentId;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  const ExecutePaymentResultDto({
    required this.isSuccess,
    this.message,
    this.paymentUrl,
    this.transactionId,
    this.invoiceId,
    this.paymentId,
    this.createdAt,
  });

  factory ExecutePaymentResultDto.fromJson(Map<String, dynamic> json) =>
      _$ExecutePaymentResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ExecutePaymentResultDtoToJson(this);
}

@JsonSerializable()
class VerifyPaymentResponseDto {
  @JsonKey(name: 'deposit_id')
  final String depositId;
  final String status;
  final String? message;
  @JsonKey(name: 'transaction_id')
  final String? transactionId;
  final double? amount;
  final String? currency;

  const VerifyPaymentResponseDto({
    required this.depositId,
    required this.status,
    this.message,
    this.transactionId,
    this.amount,
    this.currency,
  });

  factory VerifyPaymentResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyPaymentResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyPaymentResponseDtoToJson(this);

  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isFailed => status.toLowerCase() == 'failed';
}
