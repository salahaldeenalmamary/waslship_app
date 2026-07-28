import '../../../imports/imports.dart';

/// A button that handles async operations with built-in loading, error, and success states
class AsyncButton extends StatefulWidget {
  /// The button label text
  final String label;

  /// Async operation to execute (must return Result)
  final Future<Result<dynamic>> Function() onPressed;

  /// Optional icon to display before the label
  final IconData? icon;

  /// Optional success message to show via toast
  final String? successMessage;

  /// Whether to show success toast (defaults to true)
  final bool showSuccessToast;

  /// Whether to show error toast (defaults to true)
  final bool showErrorToast;

  /// Callback on successful operation
  final VoidCallback? onSuccess;

  /// Callback on error
  final void Function(String message)? onError;

  /// Button style override
  final ButtonStyle? style;

  /// Button width
  final double? width;

  /// Button height
  final double? height;

  /// Whether button is initially enabled
  final bool enabled;

  /// Button type
  final AsyncButtonType type;

  const AsyncButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.successMessage,
    this.showSuccessToast = true,
    this.showErrorToast = true,
    this.onSuccess,
    this.onError,
    this.style,
    this.width,
    this.height,
    this.enabled = true,
    this.type = AsyncButtonType.elevated,
  });

  /// Primary elevated button constructor
  const AsyncButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.successMessage,
    this.showSuccessToast = true,
    this.showErrorToast = true,
    this.onSuccess,
    this.onError,
    this.style,
    this.width,
    this.height = 54,
    this.enabled = true,
    this.type = AsyncButtonType.elevated,
  });

  /// Outlined button constructor
  const AsyncButton.outlined({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.successMessage,
    this.showSuccessToast = true,
    this.showErrorToast = true,
    this.onSuccess,
    this.onError,
    this.style,
    this.width,
    this.height = 44,
    this.enabled = true,
    this.type = AsyncButtonType.outlined,
  });

  /// Text button constructor
  const AsyncButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.successMessage,
    this.showSuccessToast = true,
    this.showErrorToast = true,
    this.onSuccess,
    this.onError,
    this.style,
    this.width,
    this.height,
    this.enabled = true,
    this.type = AsyncButtonType.text,
  });

  /// Icon button constructor
  const AsyncButton.icon({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.successMessage,
    this.showSuccessToast = true,
    this.showErrorToast = true,
    this.onSuccess,
    this.onError,
    this.style,
    this.width,
    this.height,
    this.enabled = true,
    this.type = AsyncButtonType.elevated,
  });

  @override
  State<AsyncButton> createState() => _AsyncButtonState();
}

enum AsyncButtonType { elevated, outlined, text }

class _AsyncButtonState extends State<AsyncButton> {
  bool _isLoading = false;

  Future<void> _handlePress() async {
    if (_isLoading || !widget.enabled) return;

    setState(() => _isLoading = true);

    try {
      final result = await widget.onPressed();

      if (!mounted) return;

      setState(() => _isLoading = false);

      // Handle result using fold
      result.fold(
        onOk: (_) {
          if (widget.showSuccessToast && widget.successMessage != null) {
            AppToast.success(context, message: widget.successMessage!);
          }
          widget.onSuccess?.call();
        },
        onErr: (message, cause) {
          if (widget.showErrorToast) {
            AppToast.error(context, message: message);
          }
          widget.onError?.call(message);
        },
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      if (widget.showErrorToast) {
        AppToast.error(context, message: 'حدث خطأ غير متوقع');
      }
      widget.onError?.call('حدث خطأ غير متوقع');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    Widget buttonChild = _isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: widget.type == AsyncButtonType.elevated
                  ? colors.onPrimary
                  : colors.primary,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 18),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(widget.label, overflow: TextOverflow.ellipsis),
              ),
            ],
          );

    final buttonStyle = _getButtonStyle(colors);

    Widget button;
    switch (widget.type) {
      case AsyncButtonType.elevated:
        button = ElevatedButton(
          onPressed: (_isLoading || !widget.enabled) ? null : _handlePress,
          style: buttonStyle,
          child: buttonChild,
        );
        break;
      case AsyncButtonType.outlined:
        button = OutlinedButton(
          onPressed: (_isLoading || !widget.enabled) ? null : _handlePress,
          style: buttonStyle,
          child: buttonChild,
        );
        break;
      case AsyncButtonType.text:
        button = TextButton(
          onPressed: (_isLoading || !widget.enabled) ? null : _handlePress,
          style: buttonStyle,
          child: buttonChild,
        );
        break;
    }

    if (widget.width != null || widget.height != null) {
      return SizedBox(
        width: widget.width ?? double.infinity,
        height: widget.height,
        child: button,
      );
    }

    return button;
  }

  ButtonStyle _getButtonStyle(ColorScheme colors) {
    final baseStyle = widget.style ?? const ButtonStyle();

    switch (widget.type) {
      case AsyncButtonType.elevated:
        return ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          disabledBackgroundColor: colors.surfaceContainerHigh,
          disabledForegroundColor: colors.outline,
          minimumSize: Size(widget.width ?? 0, widget.height ?? 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ).merge(baseStyle);
      case AsyncButtonType.outlined:
        return OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          minimumSize: Size(widget.width ?? 0, widget.height ?? 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: BorderSide(color: colors.outlineVariant),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ).merge(baseStyle);
      case AsyncButtonType.text:
        return TextButton.styleFrom(
          foregroundColor: colors.primary,
          minimumSize: Size(widget.width ?? 0, widget.height ?? 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ).merge(baseStyle);
    }
  }
}
