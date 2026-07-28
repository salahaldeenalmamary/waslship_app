import 'package:flutter/material.dart';
import 'package:waslship/src/data/network/network.dart';
import '../../imports/packages_imports.dart';
import '../shared/shared.dart';

class AsyncHandler {
  /// Execute an async operation with toast notifications
  static Future<T?> run<T>({
    required BuildContext context,
    required Future<Result<T>> Function() operation,
    String? loadingMessage,
    String? successMessage,
    VoidCallback? onSuccess,
    bool showLoading = true,
    bool showSuccess = true,
    bool showError = true,
  }) async {
    ToastBar? loadingToast;

    // Show loading toast
    if (showLoading && loadingMessage != null) {
      loadingToast = AppToast.loading(context, message: loadingMessage);
    }

    try {
      final result = await operation();

      // Remove loading toast
      loadingToast?.remove();

      return result.fold(
        onOk: (value) {
          if (showSuccess && successMessage != null) {
            AppToast.success(context, message: successMessage);
          }
          onSuccess?.call();
          return value;
        },
        onErr: (message, _) {
          if (showError) {
            AppToast.error(context, message: message);
          }
          return null;
        },
      );
    } catch (e) {
      loadingToast?.remove();

      if (showError) {
        AppToast.error(context, message: 'حدث خطأ غير متوقع');
      }
      return null;
    }
  }
}

extension AsyncHandlerExt<T> on Result<T> {
  /// Handle the result with toast notifications
  T? handleWithToast({
    required BuildContext context,
    String? successMessage,
    VoidCallback? onSuccess,
    bool showSuccess = true,
    bool showError = true,
  }) {
    return fold(
      onOk: (value) {
        if (showSuccess && successMessage != null) {
          AppToast.success(context, message: successMessage);
        }
        onSuccess?.call();
        return value;
      },
      onErr: (message, _) {
        if (showError) {
          AppToast.error(context, message: message);
        }
        return null;
      },
    );
  }

  /// Handle the result without returning a value (for void operations)
  void handleWithToastVoid({
    required BuildContext context,
    String? successMessage,
    VoidCallback? onSuccess,
    bool showSuccess = true,
    bool showError = true,
  }) {
    fold(
      onOk: (_) {
        if (showSuccess && successMessage != null) {
          AppToast.success(context, message: successMessage);
        }
        onSuccess?.call();
      },
      onErr: (message, _) {
        if (showError) {
          AppToast.error(context, message: message);
        }
      },
    );
  }

  /// Get the value or show error toast and return null
  T? getValueOrShowError({
    required BuildContext context,
    bool showError = true,
  }) {
    return fold(
      onOk: (value) => value,
      onErr: (message, _) {
        if (showError) {
          AppToast.error(context, message: message);
        }
        return null;
      },
    );
  }

  /// Show success toast if result is Ok
  void showSuccessIfOk({
    required BuildContext context,
    required String message,
  }) {
    if (isOk) {
      AppToast.success(context, message: message);
    }
  }

  /// Show error toast if result is Err
  void showErrorIfErr({required BuildContext context, bool showError = true}) {
    if (isErr && showError) {
      AppToast.error(context, message: requireError);
    }
  }
}

/// Riverpod extension for easier async handling in widgets
extension AsyncHandlerWidgetRef on WidgetRef {
  /// Execute an async operation with automatic loading state management
  Future<T?> runAsync<T>({
    required Future<Result<T>> Function() operation,
    String? loadingMessage = 'جاري التحميل...',
    String? successMessage,
    VoidCallback? onSuccess,
    bool showLoading = true,
    bool showSuccess = true,
    bool showError = true,
  }) async {
    final context = _getContext();
    if (context == null) return null;

    return AsyncHandler.run<T>(
      context: context,
      operation: operation,
      loadingMessage: loadingMessage,
      successMessage: successMessage,
      onSuccess: onSuccess,
      showLoading: showLoading,
      showSuccess: showSuccess,
      showError: showError,
    );
  }

  BuildContext? _getContext() {
    try {
      return (this as dynamic).context as BuildContext?;
    } catch (_) {
      return null;
    }
  }
}
