// File: lib/core/widgets/app_toast.dart

import 'package:flutter/material.dart';
import '../../../../data/network/network.dart';
import '../../shared.dart';

/// Pre-built toast styles for common use cases
class AppToast {
  /// Show a success toast
  static void success(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    ToastPosition position = ToastPosition.bottom,
  }) {
    ToastBar(
      toastDuration: duration,
      position: position,
      autoDismiss: true,
      animationDuration: const Duration(milliseconds: 500),
      animationCurve: Curves.easeOut,
      builder: (context) => _ToastCard(
        icon: Icons.check_circle_rounded,
        title: title ?? 'نجاح',
        message: message,
        backgroundColor: Colors.green.shade600,
        iconColor: Colors.white,
        textColor: Colors.white,
      ),
    ).show(context);
  }

  /// Show an error toast
  static void error(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
    ToastPosition position = ToastPosition.bottom,
  }) {
    ToastBar(
      toastDuration: duration,
      position: position,
      autoDismiss: true,
      animationDuration: const Duration(milliseconds: 500),
      animationCurve: Curves.easeOut,
      builder: (context) => _ToastCard(
        icon: Icons.error_outline_rounded,
        title: title ?? 'خطأ',
        message: message,
        backgroundColor: Colors.red.shade600,
        iconColor: Colors.white,
        textColor: Colors.white,
      ),
    ).show(context);
  }

  /// Show a warning toast
  static void warning(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    ToastPosition position = ToastPosition.bottom,
  }) {
    ToastBar(
      toastDuration: duration,
      position: position,
      autoDismiss: true,
      animationDuration: const Duration(milliseconds: 500),
      animationCurve: Curves.easeOut,
      builder: (context) => _ToastCard(
        icon: Icons.warning_rounded,
        title: title ?? 'تحذير',
        message: message,
        backgroundColor: Colors.orange.shade600,
        iconColor: Colors.white,
        textColor: Colors.white,
      ),
    ).show(context);
  }

  /// Show an info toast
  static void info(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    ToastPosition position = ToastPosition.bottom,
  }) {
    ToastBar(
      toastDuration: duration,
      position: position,
      autoDismiss: true,
      animationDuration: const Duration(milliseconds: 500),
      animationCurve: Curves.easeOut,
      builder: (context) => _ToastCard(
        icon: Icons.info_outline_rounded,
        title: title ?? 'معلومة',
        message: message,
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconColor: Colors.white,
        textColor: Colors.white,
      ),
    ).show(context);
  }

  /// Show a loading toast (persistent, must be dismissed manually)
  static ToastBar? loading(
    BuildContext context, {
    required String message,
    ToastPosition position = ToastPosition.bottom,
  }) {
    final toast = ToastBar(
      toastDuration: const Duration(days: 1), // Long duration
      position: position,
      autoDismiss: false,
      animationDuration: const Duration(milliseconds: 500),
      animationCurve: Curves.easeOut,
      builder: (context) => _ToastCard(
        icon: null,
        title: null,
        message: message,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        iconColor: Theme.of(context).colorScheme.primary,
        textColor: Theme.of(context).colorScheme.onSurface,
        trailing: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
    toast.show(context);
    return toast;
  }

  /// Handle Result type and show appropriate toast
  static void fromResult<T>(
    BuildContext context,
    Result<T> result, {
    String? successMessage,
    String? errorMessage,
    VoidCallback? onSuccess,
    void Function(String message)? onError,
  }) {
    result.fold(
      onOk: (_) {
        if (successMessage != null) {
          success(context, message: successMessage);
        }
        onSuccess?.call();
      },
      onErr: (message, _) {
        error(context, message: errorMessage ?? message);
        onError?.call(message);
      },
    );
  }

  /// Remove all active toasts
  static void clearAll() {
    ToastBar.removeAll();
  }
}

/// Internal toast card widget
class _ToastCard extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final String message;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final Widget? trailing;

  const _ToastCard({
    this.icon,
    this.title,
    required this.message,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  message,
                  style: TextStyle(
                    color: textColor.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 12), trailing!],
        ],
      ),
    );
  }
}
