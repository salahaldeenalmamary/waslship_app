import 'dart:async';
import '../../app/providers/auth/auth_notifier.dart';
import '../../app/providers/auth/auth_providers.dart';
import '../../app/providers/auth/auth_state.dart';
import '../../data/repositories/auth/models/auth_dtos.dart';
import '../../imports/imports.dart';

@RoutePage()
class OtpPage extends HookConsumerWidget {
  final String email;

  const OtpPage({super.key, required this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hooks
    final otpController = useTextEditingController();
    final countdown = useState(60);
    final isCounting = useState(true);
    final isVerifying = useState(false);
    final errorMessage = useState<String?>(null);
    final currentText = useState('');

    // Auth
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final authState = ref.watch(authNotifierProvider);
    final otpEmail = email ?? '';

    // Countdown timer effect
    useEffect(() {
      Timer? timer;
      if (isCounting.value && countdown.value > 0) {
        timer = Timer(const Duration(seconds: 1), () {
          countdown.value--;
          if (countdown.value <= 0) {
            isCounting.value = false;
          }
        });
      }
      return () => timer?.cancel();
    }, [countdown.value, isCounting.value]);

    // Clear error when auth state changes
    useEffect(() {
      if (authState.errorMessage != null) {
        errorMessage.value = authState.errorMessage;
      }
      return null;
    }, [authState.errorMessage]);

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(
          'التحقق من الرمز',
          style: textTheme.titleMedium?.copyWith(color: colors.onSurface),
        ),
        backgroundColor: colors.surfaceContainerLowest,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: colors.onSurface,
          ),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(Icons.security, size: 36, color: colors.primary),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'رمز التحقق',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'تم إرسال رمز التحقق المكون من 6 أرقام إلى',
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                otpEmail,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // OTP Input using pin_code_fields
              Directionality(
                textDirection: TextDirection.ltr,
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: otpController,
                  obscureText: false,
                  obscuringCharacter: '*',
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  autoFocus: true,
                  enableActiveFill: true,
                  autoDismissKeyboard: true,
                  errorAnimationDuration: 400,
                  cursorColor: colors.primary,
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: 56,
                    fieldWidth: 48,
                    activeFillColor: colors.primaryContainer.withOpacity(0.3),
                    inactiveFillColor: colors.surfaceContainerLow,
                    selectedFillColor: colors.primaryContainer.withOpacity(0.2),
                    activeColor: colors.primary,
                    inactiveColor: colors.outlineVariant,
                    selectedColor: colors.primary,
                    borderWidth: 1.5,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enablePinAutofill: true,
                  onCompleted: (value) {
                    _handleVerify(
                      ref,
                      value,
                      otpEmail,
                      authNotifier,
                      isVerifying,
                      errorMessage,
                      otpController,
                      context,
                      authState,
                    );
                  },
                  onChanged: (value) {
                    currentText.value = value;
                    // Clear error when user types
                    if (errorMessage.value != null) {
                      errorMessage.value = null;
                      authNotifier.clearError();
                    }
                  },
                  beforeTextPaste: (text) {
                    // Allow pasting only numbers
                    return RegExp(r'^\d+$').hasMatch(text ?? '');
                  },
                ),
              ),

              // Error Message
              if (errorMessage.value != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.error.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: colors.error, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMessage.value!,
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 32),

              // Verify Button
              AsyncButton.primary(
                label: 'تحقق من الرمز',
                icon: Icons.check_circle,
                onPressed: () {
                  final otpCode = otpController.text;
                  return _handleVerifyButton(
                    otpCode,
                    otpEmail,
                    authNotifier,
                    errorMessage,
                    context,
                    authState,
                  );
                },
                successMessage: 'تم التحقق بنجاح',
              ),
              const SizedBox(height: 24),

              // Resend OTP Section
              _buildResendSection(
                context,
                isCounting.value,
                countdown.value,
                otpEmail,
                authNotifier,
                otpController,
                isCounting,
                countdown,
                errorMessage,
              ),
              const SizedBox(height: 16),

              // Change Email
              TextButton.icon(
                onPressed: () => context.router.maybePop(),
                icon: Icon(
                  Icons.edit,
                  size: 16,
                  color: colors.onSurfaceVariant,
                ),
                label: Text(
                  'تغيير البريد الإلكتروني',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================
  // Resend Section
  // ============================================

  Widget _buildResendSection(
    BuildContext context,
    bool isCounting,
    int countdown,
    String otpEmail,
    AuthNotifier authNotifier,
    TextEditingController otpController,
    ValueNotifier<bool> isCountingNotifier,
    ValueNotifier<int> countdownNotifier,
    ValueNotifier<String?> errorMessage,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'لم يصلك الرمز؟ ',
          style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
        ),
        if (isCounting)
          Text(
            'إعادة الإرسال خلال ${countdown}ث',
            style: textTheme.bodySmall?.copyWith(color: colors.outline),
          )
        else
          TextButton(
            onPressed: () => _handleResend(
              otpEmail,
              authNotifier,
              otpController,
              isCountingNotifier,
              countdownNotifier,
              errorMessage,
            ),
            child: Text(
              'إعادة إرسال الرمز',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }

  // ============================================
  // Business Logic
  // ============================================

  Future<void> _handleVerify(
    WidgetRef ref,
    String otpCode,
    String otpEmail,
    AuthNotifier authNotifier,
    ValueNotifier<bool> isVerifying,
    ValueNotifier<String?> errorMessage,
    TextEditingController otpController,
    BuildContext context,
    AuthState authState,
  ) async {
    if (otpCode.length < 6) return;

    isVerifying.value = true;
    errorMessage.value = null;

    final request = VerifyOtpRequestDto(
      phoneNumber: otpEmail,
      otpCode: otpCode,
    );

    final result = await authNotifier.verifyOtp(request);

    isVerifying.value = false;

    result.fold(
      onOk: (_) {
        if (authState.status.isPasswordResetSent) {
          context.router.replace(ResetPasswordRoute(email: email));
        } else if (authState.status.isOtpVerified) {
          context.router.replaceAll([const LoginRoute()]);
        } else if (authState.status.isAuthenticated) {
          context.router.replaceAll([const LoginRoute()]);
        }
      },
      onErr: (message, _) {
        errorMessage.value = message;
        otpController.clear();
      },
    );
  }

  Future<Result<LoginResponseDto?>> _handleVerifyButton(
    String otpCode,
    String otpEmail,
    AuthNotifier authNotifier,
    ValueNotifier<String?> errorMessage,
    BuildContext context,
    AuthState authState,
  ) async {
    if (otpCode.length < 6) {
      return const Result.err('يرجى إدخال رمز التحقق كاملاً');
    }

    if (otpEmail.isEmpty) {
      return const Result.err('البريد الإلكتروني غير متوفر');
    }

    final request = VerifyOtpRequestDto(
      phoneNumber: otpEmail,
      otpCode: otpCode,
    );

    return authNotifier.verifyOtp(request);
  }

  Future<void> _handleResend(
    String otpEmail,
    AuthNotifier authNotifier,
    TextEditingController otpController,
    ValueNotifier<bool> isCounting,
    ValueNotifier<int> countdown,
    ValueNotifier<String?> errorMessage,
  ) async {
    if (otpEmail.isEmpty) return;

    final request = ResendOtpRequestDto(phoneNumber: otpEmail);
    final result = await authNotifier.resendOtp(request);

    result.fold(
      onOk: (_) {
        // Reset countdown
        countdown.value = 60;
        isCounting.value = true;

        // Clear OTP field
        otpController.clear();
        errorMessage.value = null;
      },
      onErr: (message, _) {
        errorMessage.value = message;
      },
    );
  }
}
