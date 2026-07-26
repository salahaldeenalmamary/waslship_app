import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

/// Generic envelope wrapping all API responses.
///
/// Expected server JSON shape:
/// ```json
/// { "success": true, "message": "...", "data": { ... } }
/// ```
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.meta,
  });

  final bool success;
  final String? message;
  final T? data;
  final Map<String, dynamic>? meta;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}
