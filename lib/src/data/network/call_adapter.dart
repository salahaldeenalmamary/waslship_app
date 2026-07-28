import 'package:retrofit/retrofit.dart';

import '../../imports/imports.dart';
import 'api_response.dart';

/// Enhanced Retrofit CallAdapter that handles both:
/// 1. Direct responses (Result.ok)
/// 2. Wrapped responses (ApiResponse with success/data/message)
class ApiResultAdapter<T> extends CallAdapter<Future<T>, Future<Result<T>>> {
  @override
  Future<Result<T>> adapt(Future<T> Function() call) async {
    try {
      final response = await call();

      // Check if response is an ApiResponse wrapper
      if (response is ApiResponse<T>) {
        return _handleApiResponse(response);
      }

      // Check if response is a Map (for flexibility)
      if (response is Map<String, dynamic>) {
        return _handleMapResponse(response);
      }

      // Direct response (already deserialized model)
      return Result<T>.ok(response);
    } on DioException catch (e) {
      final message = _extractDioError(e);
      return Result.err(message, cause: e);
    } catch (e) {
      if (e is Result) return e as Result<T>;
      return Result.err(e.toString(), cause: e);
    }
  }

  Result<T> _handleApiResponse(ApiResponse<T> apiResponse) {
    if (apiResponse.success) {
      if (apiResponse.data != null) {
        return Result.ok(apiResponse.data as T);
      } else {
        return Result.err('No data received', cause: null);
      }
    } else {
      final message = apiResponse.message ?? 'حدث خطأ غير معروف';
      return Result.err(message, cause: apiResponse.errors);
    }
  }

  Result<T> _handleMapResponse(Map<String, dynamic> response) {
    final success = response['success'] as bool? ?? false;

    if (success) {
      final data = response['data'];
      return Result.ok(data as T);
    } else {
      final message = response['message'] as String? ?? 'حدث خطأ غير معروف';
      final errors = response['errors'];
      return Result.err(message, cause: errors);
    }
  }

  String _extractDioError(DioException e) {
    final responseData = e.response?.data;

    // Check if response data is already deserialized as ApiResponse
    if (responseData is ApiResponse) {
      return responseData.message ?? 'حدث خطأ غير معروف';
    }

    // Handle Map response (fallback)
    if (responseData is Map<String, dynamic>) {
      // Check for message in wrapped response
      if (responseData.containsKey('message') &&
          responseData['message'] != null) {
        return responseData['message'].toString();
      }

      // Check for validation errors
      if (responseData.containsKey('errors') &&
          responseData['errors'] != null) {
        final errors = responseData['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            return firstError.first.toString();
          }
          return firstError.toString();
        }
      }
    }

    return switch (e.type) {
      DioExceptionType.connectionTimeout => 'انتهت مهلة الاتصال',
      DioExceptionType.sendTimeout => 'انتهت مهلة الإرسال',
      DioExceptionType.receiveTimeout => 'انتهت مهلة الاستجابة',
      DioExceptionType.connectionError => 'لا يوجد اتصال بالإنترنت',
      DioExceptionType.badResponse => 'خطأ في الاستجابة من الخادم',
      DioExceptionType.cancel => 'تم إلغاء الطلب',
      _ => e.message ?? 'حدث خطأ غير معروف',
    };
  }
}
