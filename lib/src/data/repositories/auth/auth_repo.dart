import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../network/api_response.dart';
import '../../network/network.dart';
import 'models/auth_dtos.dart';
part 'auth_repo.g.dart';

@RestApi(callAdapter: ApiResultAdapter)
abstract class AuthRepo {
  factory AuthRepo(Dio dio, {String baseUrl}) = _AuthRepo;

  /// Register a new user account
  @POST('/auth/register')
  Future<Result<ApiResponse<MessageResponseDto>>> register(
    @Body() RegisterRequestDto request,
  );

  /// Authenticate a user and issue a JWT
  @POST('/auth/login')
  Future<Result<ApiResponse<LoginResponseDto>>> login(
    @Body() LoginRequestDto request,
  );

  /// Verify a one-time password for account activation
  @POST('/auth/verify-otp')
  Future<Result<ApiResponse<MessageResponseDto>>> verifyOtp(
    @Body() VerifyOtpRequestDto request,
  );

  /// Resend the OTP code to the user
  @POST('/auth/resend-otp')
  Future<Result<ApiResponse<OtpResponseDto>>> resendOtp(
    @Body() ResendOtpRequestDto request,
  );

  /// Send a password reset request for an account
  @POST('/auth/forgot-password')
  Future<Result<ApiResponse<MessageResponseDto>>> forgotPassword(
    @Body() ForgotPasswordRequestDto request,
  );

  /// Reset a user's password with a valid reset token
  @POST('/auth/reset-password')
  Future<Result<ApiResponse<MessageResponseDto>>> resetPassword(
    @Body() ResetPasswordRequestDto request,
  );

  /// Refresh an expired JWT using a refresh token
  @POST('/auth/refresh-token')
  Future<Result<ApiResponse<TokenResponseDto>>> refreshToken(
    @Body() RefreshTokenRequestDto request,
  );

  /// Log out the current authenticated user
  @POST('/auth/logout')
  Future<Result<ApiResponse<MessageResponseDto>>> logout(
    @Body() LogoutRequestDto request,
  );
}
