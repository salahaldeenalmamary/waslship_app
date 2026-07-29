// File: lib/features/payment/providers/payment_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/payment/payment_dtos.dart';
import '../../../data/repositories/payment/payment_repo.dart';
import '../../../imports/imports.dart';
import 'payment_state.dart';

class PaymentNotifier extends StateNotifier<PaymentState> {
  final PaymentRepo _paymentRepo;

  PaymentNotifier(this._paymentRepo) : super(const PaymentState());

  // ============================================
  // Amount Management
  // ============================================

  void setAmount(double amount) {
    state = state.copyWith(amount: amount, errorMessage: null);
  }

  void setCurrency(String currency) {
    state = state.copyWith(currency: currency, errorMessage: null);
  }

  // ============================================
  // Step 1: Initiate Payment
  // ============================================

  /// Initiate payment to get available payment methods
  Future<Result<InitiatePaymentResponseDto>> initiatePayment(
    InitiatePaymentRequestDto request,
  ) async {
    if (state.amount <= 0) {
      return Result.err('يرجى إدخال مبلغ صحيح');
    }

    state = state.copyWith(
      step: PaymentStep.initiating,
      isLoading: true,
      errorMessage: null,
    );

    final result = await _paymentRepo.initiatePayment(request);

    result.fold(
      onOk: (response) {
        state = state.copyWith(
          step: PaymentStep.methods,
          isLoading: false,
          initiatedPayment: response,
          availableMethods: response.initiatePaymentResult.availableMethods,
          successMessage: 'تم تحميل طرق الدفع المتاحة',
        );
      },
      onErr: (message, cause) {
        state = state.copyWith(
          step: PaymentStep.error,
          isLoading: false,
          errorMessage: message,
        );
      },
    );

    return result;
  }

  // ============================================
  // Step 2: Select Payment Method
  // ============================================

  /// Select a payment method from available methods
  void selectPaymentMethod(PaymentMethodDto method) {
    state = state.copyWith(selectedMethod: method, errorMessage: null);
  }

  // ============================================
  // Step 3: Execute Payment
  // ============================================

  /// Execute payment with selected method
  Future<Result<ExecutePaymentResponseDto>> executePayment(
    ExecutePaymentRequestDto request,
  ) async {
    if (state.selectedMethod == null) {
      return Result.err('يرجى اختيار طريقة الدفع');
    }

    state = state.copyWith(
      step: PaymentStep.executing,
      isLoading: true,
      errorMessage: null,
    );

    final result = await _paymentRepo.executePayment(request);

    result.fold(
      onOk: (response) {
        final hasUrl = response.hasPaymentUrl;
        state = state.copyWith(
          step: hasUrl ? PaymentStep.paymentUrl : PaymentStep.completed,
          isLoading: false,
          executionResult: response,
          successMessage: response.executePaymentResult.message ?? 'تم إنشاء الفاتورة بنجاح',
        );
      },
      onErr: (message, cause) {
        state = state.copyWith(
          step: PaymentStep.error,
          isLoading: false,
          errorMessage: message,
        );
      },
    );

    return result;
  }

  // ============================================
  // Step 4: Verify Payment
  // ============================================

  /// Verify payment after returning from payment gateway
  Future<Result<VerifyPaymentResponseDto>> verifyPayment(
    VerifyPaymentRequestDto request,
  ) async {
    state = state.copyWith(
      step: PaymentStep.verifying,
      isLoading: true,
      errorMessage: null,
    );

    final result = await _paymentRepo.verifyPayment(request);

    result.fold(
      onOk: (response) {
        state = state.copyWith(
          step: PaymentStep.completed,
          isLoading: false,
          verificationResult: response,
          successMessage: 'تم تأكيد الدفع بنجاح',
        );
      },
      onErr: (message, cause) {
        state = state.copyWith(
          step: PaymentStep.error,
          isLoading: false,
          errorMessage: message,
        );
      },
    );

    return result;
  }

  // ============================================
  // Utility Methods
  // ============================================

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void clearSuccessMessage() {
    state = state.copyWith(successMessage: null);
  }

  void resetPayment() {
    state = const PaymentState();
  }

  void goBackToAmountInput() {
    state = state.copyWith(
      step: PaymentStep.amountInput,
      selectedMethod: null,
      executionResult: null,
      errorMessage: null,
    );
  }

  void goBackToMethods() {
    state = state.copyWith(
      step: PaymentStep.methods,
      selectedMethod: null,
      executionResult: null,
      errorMessage: null,
    );
  }
}