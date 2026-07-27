import '../../app/providers/auth/auth_providers.dart';
import '../../data/network/network.dart';
import '../../data/repositories/auth/models/auth_dtos.dart';
import '../../imports/imports.dart';

@RoutePage()
class RegisterPage extends HookConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hooks
    final showPassword = useState(false);
    final showConfirmPassword = useState(false);
    final acceptTerms = useState(false);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final phoneController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    // Auth
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(
          'إنشاء حساب جديد',
          style: textTheme.titleMedium?.copyWith(color: colors.onSurface),
        ),
        backgroundColor: colors.surfaceContainerLowest,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  controller: nameController,
                  label: 'الاسم الكامل',
                  hint: 'أدخل اسمك الكامل',
                  icon: Icons.person_outline,
                  context: context,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال الاسم الكامل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  controller: emailController,
                  label: 'البريد الإلكتروني',
                  hint: 'أدخل بريدك الإلكتروني',
                  icon: Icons.email_outlined,
                  context: context,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال البريد الإلكتروني';
                    }
                    if (!value.contains('@')) {
                      return 'يرجى إدخال بريد إلكتروني صحيح';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  controller: phoneController,
                  label: 'رقم الهاتف',
                  hint: '05XXXXXXXX',
                  context: context,
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال رقم الهاتف';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  controller: passwordController,
                  label: 'كلمة المرور',
                  hint: 'أدخل كلمة المرور',
                  context: context,
                  icon: Icons.lock_outline,
                  obscureText: !showPassword.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: colors.onSurfaceVariant,
                    ),
                    onPressed: () => showPassword.value = !showPassword.value,
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
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  controller: confirmPasswordController,
                  label: 'تأكيد كلمة المرور',
                  context: context,
                  hint: 'أعد إدخال كلمة المرور',
                  icon: Icons.lock_outline,
                  obscureText: !showConfirmPassword.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      showConfirmPassword.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: colors.onSurfaceVariant,
                    ),
                    onPressed: () =>
                        showConfirmPassword.value = !showConfirmPassword.value,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى تأكيد كلمة المرور';
                    }
                    if (value != passwordController.text) {
                      return 'كلمات المرور غير متطابقة';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Terms Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: acceptTerms.value,
                      onChanged: (v) => acceptTerms.value = v ?? false,
                      activeColor: colors.primary,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => acceptTerms.value = !acceptTerms.value,
                        child: Text(
                          'أوافق على الشروط والأحكام وسياسة الخصوصية',
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Register Button
                AsyncButton.primary(
                  label: 'إنشاء حساب',
                  icon: Icons.person_add,
                  onPressed: () async {
                    if (!(formKey.currentState?.validate() ?? false)) {
                      return const Result.err('يرجى تصحيح الأخطاء في النموذج');
                    }

                    if (!acceptTerms.value) {
                      return const Result.err(
                        'يرجى الموافقة على الشروط والأحكام',
                      );
                    }

                    final request = RegisterRequestDto(
                      name: nameController.text.trim(),
                      email: emailController.text.trim(),
                      phone: phoneController.text.trim(),
                      password: passwordController.text,
                      passwordConfirmation: confirmPasswordController.text,
                    );

                    return authNotifier.register(request);
                  },
                  loadingMessage: 'جاري إنشاء الحساب...',
                  successMessage: 'تم إنشاء الحساب بنجاح',
                  onSuccess: () {
                    //  context.router.push(const OtpRoute());
                  },
                ),
                const SizedBox(height: 16),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'لديك حساب بالفعل؟ ',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.router.maybePop(),
                      child: Text(
                        'تسجيل الدخول',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    TextDirection? textDirection,
    String? Function(String?)? validator,
    required BuildContext context,
  }) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          textDirection: textDirection ?? TextDirection.rtl,
          textAlign: TextAlign.right,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: colors.onSurfaceVariant),
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}
