import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/repositories/auth/models/auth_dtos.dart';

part 'auth_state.freezed.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
  otpSent,
  otpVerified,
  passwordResetSent,
  passwordResetSuccess,
  registered,
}

extension AuthStatusExt on AuthStatus {
  /// Check if the status is a loading state
  bool get isLoading => this == AuthStatus.loading;

  /// Check if the status is an error state
  bool get isError => this == AuthStatus.error;

  /// Check if the user is authenticated
  bool get isAuthenticated => this == AuthStatus.authenticated;

  /// Check if the user is unauthenticated
  bool get isUnauthenticated => this == AuthStatus.unauthenticated;

  /// Check if the status is initial
  bool get isInitial => this == AuthStatus.initial;

  /// Check if OTP has been sent
  bool get isOtpSent => this == AuthStatus.otpSent;

  /// Check if OTP has been verified
  bool get isOtpVerified => this == AuthStatus.otpVerified;

  /// Check if password reset has been sent
  bool get isPasswordResetSent => this == AuthStatus.passwordResetSent;

  /// Check if password reset was successful
  bool get isPasswordResetSuccess => this == AuthStatus.passwordResetSuccess;

  /// Check if user is registered
  bool get isRegistered => this == AuthStatus.registered;

  /// Check if the status represents a success state
  bool get isSuccess => [
    AuthStatus.authenticated,
    AuthStatus.otpVerified,
    AuthStatus.passwordResetSuccess,
    AuthStatus.registered,
  ].contains(this);

  /// Check if the status represents an OTP related state
  bool get isOtpState =>
      [AuthStatus.otpSent, AuthStatus.otpVerified].contains(this);

  /// Check if the status represents a password reset related state
  bool get isPasswordResetState => [
    AuthStatus.passwordResetSent,
    AuthStatus.passwordResetSuccess,
  ].contains(this);

  /// Check if the status represents a terminal state (no further actions needed)
  bool get isTerminal => [
    AuthStatus.authenticated,
    AuthStatus.unauthenticated,
    AuthStatus.error,
    AuthStatus.otpVerified,
    AuthStatus.passwordResetSuccess,
    AuthStatus.registered,
  ].contains(this);
}

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,

    // Tokens
    String? accessToken,
    String? refreshToken,
    String? phone,
    // Error/Success messages
    String? errorMessage,
    String? successMessage,

    // User data
    UserDto? user,
  }) = _AuthState;

  const AuthState._();

  bool get isLoggedIn => accessToken != null && user != null;
  bool get isLoading => status == AuthStatus.loading;
  bool get hasError => errorMessage != null;
}
