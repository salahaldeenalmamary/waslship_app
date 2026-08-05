import '../../../data/repositories/payment/payment_dtos.dart';
import '../../../data/repositories/payment/payment_repo.dart';
import '../../../imports/imports.dart';
import 'payment_providers.dart';
import 'payment_state.dart';

// Provider definition
final paymentNotifierProvider = NotifierProvider<PaymentNotifier, PaymentState>(
  () => PaymentNotifier(),
);

class PaymentNotifier extends Notifier<PaymentState> {
  late final PaymentRepo _paymentRepo;

  @override
  PaymentState build() {
    _paymentRepo = ref.read(paymentRepoProvider);
    return const PaymentState();
  }

  // ============================================
  // Amount Management
  // ============================================

  void setAmount(double amount) {
    state = state.copyWith(amount: amount, errorMessage: null);
  }

  void setCurrency(String currency) {
    // Fixed: Removed Mutation<void>; - was incomplete code
    state = state.copyWith(currency: currency, errorMessage: null);
  }

  // ============================================
  // Step 1: Initiate Payment
  // ============================================

  /// Initiate payment to get available payment methods
  Future<Result<InitiatePaymentResponseDto?>> initiatePayment(
    InitiatePaymentRequestDto request,
  ) async {
    if (state.amount <= 0) {
      return const Result.err('يرجى إدخال مبلغ صحيح');
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
          initiatedPayment: response.data,
          availableMethods:
              response.data?.initiatePaymentResult.availableMethods ?? [],
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

    return result.toDataResult();
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
  Future<Result<ExecutePaymentResponseDto?>> executePayment(
    ExecutePaymentRequestDto request,
  ) async {
    state = state.copyWith(
      step: PaymentStep.executing,
      isLoading: true,
      errorMessage: null,
    );

    final result = await _paymentRepo.executePayment(request);

    result.fold(
      onOk: (response) {
        final hasUrl = response.data?.hasPaymentUrl ?? false;
        state = state.copyWith(
          step: hasUrl ? PaymentStep.paymentUrl : PaymentStep.completed,
          isLoading: false,
          executionResult: response.data,
          successMessage:
              response.data?.executePaymentResult.message ??
              'تم إنشاء الفاتورة بنجاح',
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

    return result.toDataResult();
  }

  // ============================================
  // Step 4: Verify Payment
  // ============================================

  /// Verify payment after returning from payment gateway
  Future<Result<VerifyPaymentResponseDto?>> verifyPayment(
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
          verificationResult: response.data,
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

    return result.toDataResult();
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
