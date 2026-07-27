import 'dart:io';

import 'package:dio/io.dart';

import '../../imports/imports.dart';
import '../../data/repositories/auth/models/auth_dtos.dart';
import 'auth/auth_providers.dart';

// ============================================
// Dio Provider
// ============================================

/// Main Dio instance provider
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

  // Add interceptors - DON'T use ref.watch inside interceptors
  // Instead, pass the ref to the interceptor so it can read when needed
  dio.interceptors.addAll([
    AuthInterceptor(ref),
    ErrorInterceptor(),
    LogInterceptor(requestBody: true, responseBody: true),
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
    final token = await _getStoredToken();

    // Add authorization header if token exists
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Add language header
    options.headers['Accept-Language'] = 'ar';

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - try to refresh token
    if (err.response?.statusCode == 401) {
      if (!_isRefreshing) {
        _isRefreshing = true;
        try {
          // Read from provider only when needed (not during initialization)
          final notifier = _ref.read(authNotifierProvider.notifier);
          final refreshToken = await _getStoredRefreshToken();

          if (refreshToken != null) {
            final request = RefreshTokenRequestDto(refreshToken: refreshToken);
            final result = await notifier.refreshToken(request);

            result.fold(
              onOk: (_) {
                _isRefreshing = false;
                // Retry the original request with new token
                final newToken = _ref.read(authNotifierProvider).accessToken;
                err.requestOptions.headers['Authorization'] =
                    'Bearer $newToken';
                _retryRequest(err.requestOptions, handler);
              },
              onErr: (message, _) {
                _isRefreshing = false;
                // Refresh failed - logout user
                notifier.logout();
                handler.next(err);
              },
            );
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

  Future<String?> _getStoredToken() async {
    try {
      return _ref.read(authNotifierProvider).accessToken;
    } catch (e) {
      return null;
    }
  }

  Future<String?> _getStoredRefreshToken() async {
    try {
      return _ref.read(authNotifierProvider).refreshToken;
    } catch (e) {
      return null;
    }
  }

  Future<void> _retryRequest(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final dio = Dio();
      final response = await dio.fetch(requestOptions);
      handler.resolve(response);
    } catch (e) {
      handler.next(DioException(requestOptions: requestOptions, error: e));
    }
  }
}

// ============================================
// Error Interceptor
// ============================================

/// Interceptor for global error handling
class ErrorInterceptor extends Interceptor {
  ErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle specific error cases
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
          case 502:
            message = 'خطأ في البوابة';
            break;
          case 503:
            message = 'الخدمة غير متاحة حالياً';
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

  /// Extract error message from response data
  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      if (data.containsKey('message')) {
        return data['message'] as String?;
      }
      if (data.containsKey('error')) {
        final error = data['error'];
        if (error is String) return error;
        if (error is Map && error.containsKey('message')) {
          return error['message'] as String?;
        }
      }
      if (data.containsKey('errors')) {
        final errors = data['errors'];
        if (errors is Map) {
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            return firstError.first.toString();
          }
        }
      }
    }

    return null;
  }
}

// ============================================
// Network Interceptor
// ============================================

/// Interceptor to check network connectivity
class NetworkInterceptor extends Interceptor {
  final Ref _ref;

  NetworkInterceptor(this._ref);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final hasConnection = await _ref.read(networkInfoProvider).hasConnection;

    if (!hasConnection) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: 'لا يوجد اتصال بالإنترنت',
        ),
      );
      return;
    }

    handler.next(options);
  }
}

// ============================================
// Network Info Provider
// ============================================

/// Provider to check network connectivity
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfo();
});

class NetworkInfo {
  Future<bool> get hasConnection async {
    return await InternetConnectionService().hasConnection();
  }
}

/// Clean Dio instance for token refresh (to avoid interceptor loops)
final refreshDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
});

void _configureDevSsl(Dio dio) {
  try {
    // Create a custom HttpClient that trusts all certificates in development
    final httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        // Only bypass SSL for known development hosts
        const allowedHosts = ['localhost', '10.0.2.2'];

        if (allowedHosts.contains(host)) {
          debugPrint('🔓 SSL verification bypassed for $host:$port');
          return true;
        }

        // Allow local network IPs
        if (host.startsWith('192.168.') ||
            host.startsWith('172.16.') ||
            host.startsWith('10.0.')) {
          debugPrint(
            '🔓 SSL verification bypassed for local network: $host:$port',
          );
          return true;
        }

        return false;
      };

    // Set the custom adapter
    dio.httpClientAdapter = IOHttpClientAdapter()
      ..onHttpClientCreate = (_) => httpClient;
  } catch (e) {
    debugPrint('⚠️ Failed to configure SSL: $e');
  }
}
