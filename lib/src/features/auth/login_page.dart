import 'package:waslship/src/app/providers/auth/auth_state.dart';

import '../../app/providers/auth/auth_providers.dart';
import '../../data/repositories/auth/models/auth_dtos.dart';
import '../../imports/imports.dart';

enum LoginMethod { email, phone }

@RoutePage()
class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showPassword = useState(false);
    final rememberMe = useState(false);
    final loginMethod = useState(LoginMethod.email);

    // Controllers with auto-dispose
    final emailController = useTextEditingController();
    final phoneController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // Focus nodes
    final emailFocusNode = useFocusNode();
    final phoneFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();

    // Auth state
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    // Check if already authenticated on mount
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (authState.isLoggedIn) {
          context.router.replace(const AppShellRoute());
        }
      });
      return null;
    }, []);

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surfaceContainer,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Icon
                  _buildLogo(colors),
                  const SizedBox(height: 24),

                  // Title
                  _buildTitle(textTheme, colors),
                  const SizedBox(height: 8),
                  _buildSubtitle(textTheme, colors),
                  const SizedBox(height: 32),

                  // Error Banner
                  if (authState.errorMessage != null)
                    _buildErrorBanner(
                      authState.errorMessage!,
                      context,
                      () => authNotifier.clearError(),
                    ),

                  // Login Method Toggle (Email / Phone)
                  _buildLoginMethodToggle(
                    loginMethod.value,
                    (method) => loginMethod.value = method,
                    colors,
                    textTheme,
                  ),
                  const SizedBox(height: 20),

                  // Email or Phone Field
                  if (loginMethod.value == LoginMethod.email) ...[
                    _buildLabel(context, 'البريد الإلكتروني'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: emailController,
                      focusNode: emailFocusNode,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        passwordFocusNode.requestFocus();
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال البريد الإلكتروني';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'يرجى إدخال بريد إلكتروني صحيح';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'example@email.com',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: colors.onSurfaceVariant,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ] else ...[
                    _buildLabel(context, 'رقم الهاتف'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: phoneController,
                      focusNode: phoneFocusNode,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        passwordFocusNode.requestFocus();
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال رقم الهاتف';
                        }
                        final cleaned = value.replaceAll(RegExp(r'\D'), '');
                        if (cleaned.length < 9) {
                          return 'يرجى إدخال رقم هاتف صحيح';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: '05XXXXXXXX',
                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 12),
                            Text(
                              '+966',
                              style: TextStyle(
                                color: colors.onSurface,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 24,
                              color: colors.outlineVariant,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                            ),
                          ],
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),

                  // Password Field
                  _buildLabel(context, 'كلمة المرور'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    obscureText: !showPassword.value,
                    textInputAction: TextInputAction.done,

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال كلمة المرور';
                      }
                      if (value.length < 6) {
                        return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'أدخل كلمة المرور',
                      prefixIcon: Icon(
                        Icons.key_outlined,
                        color: colors.onSurfaceVariant,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: colors.onSurfaceVariant,
                        ),
                        onPressed: () =>
                            showPassword.value = !showPassword.value,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),

                  // Forgot Password & Remember Me
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Remember Me
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: rememberMe.value,
                                onChanged: (v) => rememberMe.value = v ?? false,
                                activeColor: colors.primary,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => rememberMe.value = !rememberMe.value,
                              child: Text(
                                'تذكرني',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Forgot Password
                        TextButton(
                          onPressed: () {
                            context.router.push(const ForgotPasswordRoute());
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'هل نسيت كلمة المرور؟',
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Login Button
                  AsyncButton.primary(
                    label: 'تسجيل الدخول',
                    icon: Icons.login_rounded,
                    onPressed: () => _handleLogin(
                      ref,
                      formKey,
                      loginMethod.value,
                      emailController.text,
                      phoneController.text,
                      passwordController.text,
                      rememberMe.value,
                      context,
                    ),
                    successMessage: 'تم تسجيل الدخول بنجاح',
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  _buildDivider(textTheme, colors),
                  const SizedBox(height: 20),

                  // Register
                  _buildRegisterRow(textTheme, colors, context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================
  // Login Method Toggle
  // ============================================

  Widget _buildLoginMethodToggle(
    LoginMethod currentMethod,
    ValueChanged<LoginMethod> onChanged,
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.outlineVariant.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(LoginMethod.email),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: currentMethod == LoginMethod.email
                      ? colors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 18,
                      color: currentMethod == LoginMethod.email
                          ? colors.onPrimary
                          : colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'البريد الإلكتروني',
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: currentMethod == LoginMethod.email
                            ? colors.onPrimary
                            : colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(LoginMethod.phone),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: currentMethod == LoginMethod.phone
                      ? colors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone_outlined,
                      size: 18,
                      color: currentMethod == LoginMethod.phone
                          ? colors.onPrimary
                          : colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'رقم الهاتف',
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: currentMethod == LoginMethod.phone
                            ? colors.onPrimary
                            : colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // Business Logic
  // ============================================

  Future<Result<LoginResponseDto?>> _handleLogin(
    WidgetRef ref,
    GlobalKey<FormState> formKey,
    LoginMethod loginMethod,
    String email,
    String phone,
    String password,
    bool rememberMe,
    BuildContext context,
  ) async {
    // Dismiss keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    // Validate form
    if (!(formKey.currentState?.validate() ?? false)) {
      return const Result.err('يرجى تصحيح الأخطاء في النموذج');
    }

    // Create login request based on method
    final request = LoginRequestDto(
      emailOrPhone: loginMethod == LoginMethod.email ? email.trim() : phone,
      password: password,
      deviceToken: null,
      deviceType: 'android',
    );

    // Call the auth notifier
    final result = await ref.read(authNotifierProvider.notifier).login(request);

    // Handle remember me
    result.fold(
      onOk: (_) {
        if (ref.read(authNotifierProvider).status.isOtpSent) {
          context.router.push(
            OtpRoute(email: ref.read(authNotifierProvider).phone ?? email),
          );
        } else if (ref.read(authNotifierProvider).status.isAuthenticated) {
          context.router.replace(const AppShellRoute());
        }
      },
      onErr: (_, __) {},
    );

    return result;
  }

  // ============================================
  // UI Components
  // ============================================

  Widget _buildLogo(ColorScheme colors) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        Icons.lock_outline_rounded,
        size: 36,
        color: colors.onPrimary,
      ),
    );
  }

  Widget _buildTitle(TextTheme textTheme, ColorScheme colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'وصل شيب',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.primary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '|',
            style: textTheme.headlineSmall?.copyWith(
              color: const Color(0xFFC5A059),
            ),
          ),
        ),
        Text(
          'WaslShip',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: const Color(0xFFC5A059),
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle(TextTheme textTheme, ColorScheme colors) {
    return Text(
      'مرحباً بك مجدداً في بوابة الأعمال الإلكترونية',
      style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildErrorBanner(
    String errorMessage,
    BuildContext context,
    VoidCallback onDismiss,
  ) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colors.error, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              errorMessage,
              style: textTheme.bodySmall?.copyWith(
                color: colors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: onDismiss,
            child: Icon(Icons.close, color: colors.error, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(TextTheme textTheme, ColorScheme colors) {
    return Row(
      children: [
        Expanded(child: Divider(color: colors.outlineVariant)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'أو المتابعة باستخدام',
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(child: Divider(color: colors.outlineVariant)),
      ],
    );
  }

  Widget _buildRegisterRow(
    TextTheme textTheme,
    ColorScheme colors,
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ليس لديك حساب؟ ',
          style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
        ),
        TextButton(
          onPressed: () {
            context.router.push(const RegisterRoute());
          },
          child: Text(
            'إنشاء حساب جديد',
            style: textTheme.bodyMedium?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(BuildContext context, String label) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        label,
        style: textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: colors.onSurface,
        ),
      ),
    );
  }
}
