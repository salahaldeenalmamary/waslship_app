import 'package:json_annotation/json_annotation.dart';

part 'auth_dtos.g.dart';

@JsonSerializable()
class LoginRequestDto {
  final String email;
  final String password;
  final String? deviceToken;
  final String? deviceType;

  const LoginRequestDto({
    required this.email,
    required this.password,
    this.deviceToken,
    this.deviceType,
  });

  factory LoginRequestDto.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestDtoToJson(this);
}

@JsonSerializable()
class RegisterRequestDto {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final String? userType;

  const RegisterRequestDto({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    this.userType,
  });

  factory RegisterRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestDtoToJson(this);
}

@JsonSerializable()
class VerifyOtpRequestDto {
  final String email;
  final String otp;

  const VerifyOtpRequestDto({required this.email, required this.otp});

  factory VerifyOtpRequestDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpRequestDtoToJson(this);
}

@JsonSerializable()
class ResendOtpRequestDto {
  final String email;

  const ResendOtpRequestDto({required this.email});

  factory ResendOtpRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ResendOtpRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResendOtpRequestDtoToJson(this);
}

@JsonSerializable()
class ForgotPasswordRequestDto {
  final String email;

  const ForgotPasswordRequestDto({required this.email});

  factory ForgotPasswordRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordRequestDtoToJson(this);
}

@JsonSerializable()
class ResetPasswordRequestDto {
  final String email;
  final String token;
  final String password;
  final String passwordConfirmation;

  const ResetPasswordRequestDto({
    required this.email,
    required this.token,
    required this.password,
    required this.passwordConfirmation,
  });

  factory ResetPasswordRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordRequestDtoToJson(this);
}

@JsonSerializable()
class RefreshTokenRequestDto {
  final String refreshToken;

  const RefreshTokenRequestDto({required this.refreshToken});

  factory RefreshTokenRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenRequestDtoToJson(this);
}

@JsonSerializable()
class LogoutRequestDto {
  final String? deviceToken;

  const LogoutRequestDto({this.deviceToken});

  factory LogoutRequestDto.fromJson(Map<String, dynamic> json) =>
      _$LogoutRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LogoutRequestDtoToJson(this);
}

// ============================================
// Response DTOs
// ============================================

@JsonSerializable()
class LoginResponseDto {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final UserDto user;

  const LoginResponseDto({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseDtoToJson(this);
}

@JsonSerializable()
class UserDto {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? userType;
  final bool isVerified;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserDto({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.userType,
    required this.isVerified,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}

@JsonSerializable()
class MessageResponseDto {
  final String message;

  const MessageResponseDto({required this.message});

  factory MessageResponseDto.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MessageResponseDtoToJson(this);
}

@JsonSerializable()
class TokenResponseDto {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;

  const TokenResponseDto({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory TokenResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TokenResponseDtoToJson(this);
}

@JsonSerializable()
class OtpResponseDto {
  final String message;
  final String? otp;

  const OtpResponseDto({required this.message, this.otp});

  factory OtpResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OtpResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OtpResponseDtoToJson(this);
}
