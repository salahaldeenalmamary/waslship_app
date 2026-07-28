import 'package:json_annotation/json_annotation.dart';
import '../../imports/imports.dart';

part 'api_response.g.dart';

/// Generic API response wrapper
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final dynamic errors;
  final String? timestamp;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.errors,
    this.timestamp,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT, // Removed nullable ?
  ) {
    return _$ApiResponseFromJson<T>(json, fromJsonT);
  }

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);

  /// Convert API response to Result type
  Result<T> toResult() {
    if (success && data != null) {
      return Result.ok(data as T);
    } else {
      final errorMsg =
          message ?? _extractErrorMessage(errors) ?? 'حدث خطأ غير معروف';
      return Result.err(errorMsg, cause: errors);
    }
  }

  String? _extractErrorMessage(dynamic errors) {
    if (errors == null) return null;
    if (errors is String) return errors;
    if (errors is Map) {
      final values = errors.values;
      if (values.isNotEmpty) {
        final first = values.first;
        if (first is List && first.isNotEmpty) {
          return first.first.toString();
        }
        return first.toString();
      }
    }
    return errors.toString();
  }
}

/// For responses that return a list
@JsonSerializable(genericArgumentFactories: true)
class ApiListResponse<T> {
  final bool success;
  final String? message;
  final List<T>? data;
  final dynamic errors;
  final String? timestamp;

  const ApiListResponse({
    required this.success,
    this.message,
    this.data,
    this.errors,
    this.timestamp,
  });

  factory ApiListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT, // Removed nullable ?
  ) {
    return _$ApiListResponseFromJson<T>(json, fromJsonT);
  }

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiListResponseToJson(this, toJsonT);

  Result<List<T>> toResult() {
    if (success && data != null) {
      return Result.ok(data!);
    } else {
      return Result.err(message ?? 'حدث خطأ غير معروف', cause: errors);
    }
  }
}
