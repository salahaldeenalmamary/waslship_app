import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/repositories/payment/payment_dtos.dart';

part 'payment_state.freezed.dart';

enum PaymentStep {
  initial,
  amountInput,
  initiating,
  methods,
  executing,
  paymentUrl,
  verifying,
  completed,
  error
}

@freezed
sealed class PaymentState with _$PaymentState {
  const factory PaymentState({
    @Default(PaymentStep.initial) PaymentStep step,
    @Default(0.0) double amount,
    @Default('SAR') String currency,
    InitiatePaymentResponseDto? initiatedPayment,
    ExecutePaymentResponseDto? executionResult,
    VerifyPaymentResponseDto? verificationResult,
    PaymentMethodDto? selectedMethod,
    @Default([]) List<PaymentMethodDto> availableMethods,
    @Default(false) bool isLoading,
    String? errorMessage,
    String? successMessage,
  }) = _PaymentState;

  const PaymentState._();

  String? get depositId => initiatedPayment?.depositId;
  String? get paymentUrl => executionResult?.paymentUrl;
  bool get hasPaymentUrl => executionResult?.hasPaymentUrl ?? false;
  bool get hasMethods => availableMethods.isNotEmpty;
  bool get isPaymentComplete => executionResult?.isSuccess ?? false;
}