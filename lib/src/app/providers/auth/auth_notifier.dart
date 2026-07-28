import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/network/network.dart';
import '../../../data/repositories/auth/auth_repo.dart';
import '../../../data/repositories/auth/models/auth_dtos.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepo _authRepo;

  AuthNotifier(this._authRepo) : super(const AuthState());

  Future<Result<LoginResponseDto?>> login(LoginRequestDto request) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final result = await _authRepo.login(request);

    result.fold(
      onOk: (response) {
        state = state.copyWith(
          status: response.data?.requiresOtp ?? false
              ? AuthStatus.otpSent
              : AuthStatus.authenticated,
          accessToken: response.data?.accessToken,
          refreshToken: response.data?.refreshToken,
          user: response.data?.user,
          phone: response.data?.phoneNumber,
          errorMessage: null,
          successMessage: 'تم تسجيل الدخول بنجاح',
        );
      },
      onErr: (message, cause) {
        state = state.copyWith(status: AuthStatus.error, errorMessage: message);
      },
    );

    return result.toDataResult();
  }

  // ============================================
  // Register
  // ============================================
  Future<Result<MessageResponseDto?>> register(
    RegisterRequestDto request,
  ) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final result = await _authRepo.register(request);

    result.fold(
      onOk: (response) {
        state = state.copyWith(
          status: AuthStatus.registered,
          errorMessage: null,
          successMessage: 'تم إنشاء الحساب بنجاح',
        );
      },
      onErr: (message, cause) {
        state = state.copyWith(status: AuthStatus.error, errorMessage: message);
      },
    );

    return result.toDataResult();
  }

  // ============================================
  // Verify OTP
  // ============================================
  Future<Result<LoginResponseDto?>> verifyOtp(
    VerifyOtpRequestDto request,
  ) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final result = await _authRepo.verifyOtp(request);

    result.fold(
      onOk: (response) {
        state = state.copyWith(
          status: AuthStatus.otpVerified,
          errorMessage: null,
          accessToken: response.data?.accessToken,
          refreshToken: response.data?.refreshToken,
          user: response.data?.user,
          phone: response.data?.phoneNumber,
          successMessage: 'تم التحقق بنجاح',
        );
      },
      onErr: (message, cause) {
        state = state.copyWith(status: AuthStatus.error, errorMessage: message);
      },
    );

    return result.toDataResult();
  }

  // ============================================
  // Resend OTP
  // ============================================
  Future<Result<OtpResponseDto?>> resendOtp(ResendOtpRequestDto request) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final result = await _authRepo.resendOtp(request);

    result.fold(
      onOk: (response) {
        state = state.copyWith(
          status: AuthStatus.otpSent,
          errorMessage: null,
          successMessage: 'تم إرسال رمز التحقق',
        );
      },
      onErr: (message, cause) {
        state = state.copyWith(status: AuthStatus.error, errorMessage: message);
      },
    );

    return result.toDataResult();
  }

  // ============================================
  // Forgot Password
  // ============================================
  Future<Result<MessageResponseDto?>> forgotPassword(
    ForgotPasswordRequestDto request,
  ) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final result = await _authRepo.forgotPassword(request);

    result.fold(
      onOk: (response) {
        state = state.copyWith(
          status: AuthStatus.passwordResetSent,

          errorMessage: null,
          successMessage: 'تم إرسال رابط إعادة تعيين كلمة المرور',
        );
      },
      onErr: (message, cause) {
        state = state.copyWith(status: AuthStatus.error, errorMessage: message);
      },
    );

    return result.toDataResult();
  }

  // ============================================
  // Reset Password
  // ============================================
  Future<Result<MessageResponseDto?>> resetPassword(
    ResetPasswordRequestDto request,
  ) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final result = await _authRepo.resetPassword(request);

    result.fold(
      onOk: (response) {
        state = state.copyWith(
          status: AuthStatus.passwordResetSuccess,
          errorMessage: null,
          successMessage: 'تم إعادة تعيين كلمة المرور بنجاح',
        );
      },
      onErr: (message, cause) {
        state = state.copyWith(status: AuthStatus.error, errorMessage: message);
      },
    );

    return result.toDataResult();
  }

  // ============================================
  // Refresh Token
  // ============================================
  Future<Result<TokenResponseDto?>> refreshToken(
    RefreshTokenRequestDto request,
  ) async {
    final result = await _authRepo.refreshToken(request);

    result.fold(
      onOk: (response) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          accessToken: response.data?.accessToken,
          refreshToken: response.data?.refreshToken,
          errorMessage: null,
        );
      },
      onErr: (message, cause) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: 'فشل تجديد الجلسة، يرجى تسجيل الدخول مرة أخرى',
          accessToken: null,
          refreshToken: null,
          user: null,
        );
      },
    );

    return result.toDataResult();
  }

  // ============================================
  // Logout
  // ============================================
  Future<Result<MessageResponseDto?>> logout() async {
    state = state.copyWith(status: AuthStatus.loading);

    const request = LogoutRequestDto();
    final result = await _authRepo.logout(request);

    // Always reset state regardless of API result
    state = const AuthState();

    return result.toDataResult();
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void clearSuccessMessage() {
    state = state.copyWith(successMessage: null);
  }

  void resetState() {
    state = const AuthState();
  }

  void updateAccessToken(String token) {
    state = state.copyWith(accessToken: token);
  }

  void updateRefreshToken(String token) {
    state = state.copyWith(refreshToken: token);
  }
}
