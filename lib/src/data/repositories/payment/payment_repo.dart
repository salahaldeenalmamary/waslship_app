import 'package:retrofit/retrofit.dart';
import '../../../imports/imports.dart';
import 'payment_dtos.dart';

part 'payment_repo.g.dart';

@RestApi(callAdapter: ApiResultAdapter)
abstract class PaymentRepo {
  factory PaymentRepo(Dio dio, {String baseUrl}) = _PaymentRepo;

  /// Step 1: Initiate payment - returns available methods
  @POST('/api/v1/payment/initiate')
  Future<Result<InitiatePaymentResponseDto>> initiatePayment(
    @Body() InitiatePaymentRequestDto request,
  );

  /// Step 2: Execute payment with selected method - returns payment URL
  @POST('/api/v1/payment/execute')
  Future<Result<ExecutePaymentResponseDto>> executePayment(
    @Body() ExecutePaymentRequestDto request,
  );

  /// Step 3: Verify payment status
  @POST('/api/v1/payment/verify')
  Future<Result<VerifyPaymentResponseDto>> verifyPayment(
    @Body() VerifyPaymentRequestDto request,
  );
}
