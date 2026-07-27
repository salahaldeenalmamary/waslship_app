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

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,

    // Tokens
    String? accessToken,
    String? refreshToken,

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
