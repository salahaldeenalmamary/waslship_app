import '../../app/providers/auth/auth_providers.dart';
import '../../data/network/network.dart';
import '../../data/repositories/auth/models/auth_dtos.dart';
import '../../imports/imports.dart';

@RoutePage()
class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showPassword = useState(false);
    final rememberMe = useState(false);

    // Controllers with auto-dispose
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // Focus nodes
    final emailFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();

    // ==========================================
    // Auth state
    // ==========================================
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    // ==========================================
    // Effects
    // ==========================================

    // Check if already authenticated on mount
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (authState.isLoggedIn) {
          context.router.replace(const AppShellRoute());
        }
      });
      return null;
    }, []);

    // Clear error when fields change
    useEffect(() {
      if (authState.errorMessage != null) {
        authNotifier.clearError();
      }
      return null;
    }, [emailController.text, passwordController.text]);

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
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

                  // Email Field
                  _buildLabel(context, 'البريد الإلكتروني أو رقم الهاتف'),
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
                        return 'يرجى إدخال البريد الإلكتروني أو رقم الهاتف';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'أدخل البريد الإلكتروني أو رقم الهاتف',
                      prefixIcon: Icon(
                        Icons.article_outlined,
                        color: colors.onSurfaceVariant,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
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
                    onFieldSubmitted: (_) => _handleLogin(
                      ref,
                      formKey,
                      emailController.text,
                      passwordController.text,
                      rememberMe.value,
                    ),
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
                      emailController.text,
                      passwordController.text,
                      rememberMe.value,
                    ),
                    loadingMessage: 'جاري تسجيل الدخول...',
                    successMessage: 'تم تسجيل الدخول بنجاح',
                    onSuccess: () {
                      context.router.replace(const AppShellRoute());
                    },
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
  // Business Logic (Pure Functions)
  // ============================================

  Future<Result<LoginResponseDto>> _handleLogin(
    WidgetRef ref,
    GlobalKey<FormState> formKey,
    String email,
    String password,
    bool rememberMe,
  ) async {
    // Dismiss keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    // Validate form
    if (!(formKey.currentState?.validate() ?? false)) {
      return Result.err('يرجى تصحيح الأخطاء في النموذج');
    }

    final request = LoginRequestDto(
      email: email.trim(),
      password: password,
      deviceToken: null,
      deviceType: 'android',
    );

    // Call the auth notifier
    final result = await ref.read(authNotifierProvider.notifier).login(request);

    // Handle remember me
    result.fold(
      onOk: (_) {
        if (rememberMe) {
          // TODO: Save credentials securely
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
          'WaslShip Elite',
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
