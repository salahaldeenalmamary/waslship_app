import 'package:retrofit/retrofit.dart';
import '../../../imports/imports.dart';
import '../../network/api_response.dart';
import 'payment_dtos.dart';

part 'payment_repo.g.dart';

@RestApi(callAdapter: ApiResultAdapter)
abstract class PaymentRepo {
  factory PaymentRepo(Dio dio, {String baseUrl}) = _PaymentRepo;

  /// Step 1: Initiate payment - returns available methods
  @POST('/v1/payment/initiate')
  Future<Result<ApiResponse<InitiatePaymentResponseDto>>> initiatePayment(
    @Body() InitiatePaymentRequestDto request,
  );

  /// Step 2: Execute payment with selected method - returns payment URL
  @POST('/v1/payment/execute')
  Future<Result<ApiResponse<ExecutePaymentResponseDto>>> executePayment(
    @Body() ExecutePaymentRequestDto request,
  );

  /// Step 3: Verify payment status
  @POST('/v1/payment/verify')
  Future<Result<ApiResponse<VerifyPaymentResponseDto>>> verifyPayment(
    @Body() VerifyPaymentRequestDto request,
  );
}
