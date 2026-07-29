// File: lib/data/network/dio_provider.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../services/secure_storage_service.dart';

// ============================================
// Base Dio (No Auth Interceptor)
// ============================================

/// Base Dio instance WITHOUT auth interceptor (to avoid circular dependency)
final baseDioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ),
  );

  _configureDevSsl(dio);

  dio.interceptors.addAll([
    ErrorInterceptor(),
    if (kDebugMode) LogInterceptor(requestBody: true, responseBody: true),
  ]);

  return dio;
});

// ============================================
// Main Dio (With Auth Interceptor)
// ============================================

/// Main Dio instance WITH auth interceptor
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ),
  );

  _configureDevSsl(dio);

  dio.interceptors.addAll([
    AuthInterceptor(ref),
    ErrorInterceptor(),
    if (kDebugMode) LogInterceptor(requestBody: true, responseBody: true),
  ]);

  return dio;
});

// ============================================
// Auth Interceptor
// ============================================

/// Interceptor to add auth token to requests
class AuthInterceptor extends Interceptor {
  final Ref _ref;
  bool _isRefreshing = false;

  AuthInterceptor(this._ref);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Read token directly from secure storage instead of provider
    final token = await _getTokenFromStorage();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['Accept-Language'] = 'ar';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (!_isRefreshing) {
        _isRefreshing = true;
        try {
          final refreshToken = await _getRefreshTokenFromStorage();

          if (refreshToken != null) {
            final success = await _performTokenRefresh(refreshToken);

            if (success) {
              _isRefreshing = false;
              final newToken = await _getTokenFromStorage();
              err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
              _retryRequest(err.requestOptions, handler);
            } else {
              _isRefreshing = false;
              handler.next(err);
            }
          } else {
            _isRefreshing = false;
            handler.next(err);
          }
        } catch (e) {
          _isRefreshing = false;
          handler.next(err);
        }
      } else {
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }

  Future<String?> _getTokenFromStorage() async {
    try {
      final storage = SecureStorageService.instance;
      final result = await storage.read('ACCESS_TOKEN');
      return result.fold((l) => null, (r) => r);
    } catch (e) {
      return null;
    }
  }

  Future<String?> _getRefreshTokenFromStorage() async {
    try {
      final storage = SecureStorageService.instance;
      final result = await storage.read('REFRESH_TOKEN');
      return result.fold((l) => null, (r) => r);
    } catch (e) {
      return null;
    }
  }

  Future<bool> _performTokenRefresh(String refreshToken) async {
    try {
      // Use a clean Dio instance for refresh (no interceptors)
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: AppConfig.baseUrl,
          connectTimeout: const Duration(seconds: 30),
        ),
      );

      final response = await refreshDio.post(
        '/auth/refresh-token',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final newAccessToken =
            data['data']?['access_token'] ?? data['access_token'];
        final newRefreshToken =
            data['data']?['refresh_token'] ?? data['refresh_token'];

        if (newAccessToken != null) {
          final storage = SecureStorageService.instance;
          await storage.write('ACCESS_TOKEN', newAccessToken.toString());
          if (newRefreshToken != null) {
            await storage.write('REFRESH_TOKEN', newRefreshToken.toString());
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> _retryRequest(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final retryDio = Dio();
      final response = await retryDio.fetch(requestOptions);
      handler.resolve(response);
    } catch (e) {
      handler.next(DioException(requestOptions: requestOptions, error: e));
    }
  }
}

// ============================================
// Error Interceptor
// ============================================

class ErrorInterceptor extends Interceptor {
  ErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        err = DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          type: err.type,
          message: 'انتهت مهلة الاتصال، يرجى المحاولة مرة أخرى',
        );
        break;

      case DioExceptionType.connectionError:
        err = DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          type: err.type,
          message: 'لا يوجد اتصال بالإنترنت',
        );
        break;

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final responseData = err.response?.data;

        String message;
        switch (statusCode) {
          case 400:
            message = _extractErrorMessage(responseData) ?? 'طلب غير صحيح';
            break;
          case 401:
            message = 'غير مصرح، يرجى تسجيل الدخول';
            break;
          case 403:
            message = 'غير مسموح بالوصول';
            break;
          case 404:
            message = 'غير موجود';
            break;
          case 422:
            message = _extractErrorMessage(responseData) ?? 'بيانات غير صالحة';
            break;
          case 429:
            message = 'طلبات كثيرة جداً، يرجى الانتظار';
            break;
          case 500:
            message = 'خطأ في الخادم';
            break;
          default:
            message = 'حدث خطأ غير متوقع';
        }

        err = DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          type: err.type,
          message: message,
        );
        break;

      default:
        break;
    }

    handler.next(err);
  }

  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;
    if (data is Map<String, dynamic>) {
      if (data.containsKey('message') && data['message'] != null) {
        return data['message'].toString();
      }
      if (data.containsKey('errors') && data['errors'] is Map) {
        final errors = data['errors'] as Map;
        if (errors.isNotEmpty) {
          final first = errors.values.first;
          if (first is List && first.isNotEmpty) return first.first.toString();
          return first.toString();
        }
      }
    }
    return null;
  }
}

// ============================================
// SSL Configuration (Development Only)
// ============================================

void _configureDevSsl(Dio dio) {
  try {
    final httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return host == 'localhost' ||
            host == '10.0.2.2' ||
            host.startsWith('192.168.');
      };

    dio.httpClientAdapter = IOHttpClientAdapter()
      ..onHttpClientCreate = (_) => httpClient;
  } catch (e) {
    debugPrint('Failed to configure SSL: $e');
  }
}
