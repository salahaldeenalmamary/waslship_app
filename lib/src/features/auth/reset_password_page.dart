import '../../app/providers/auth/auth_providers.dart';
import '../../data/network/network.dart';
import '../../data/repositories/auth/models/auth_dtos.dart';
import '../../imports/imports.dart';

@RoutePage()
class ResetPasswordPage extends HookConsumerWidget {
  const ResetPasswordPage({super.key, required this.email});
  final String email;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hooks
    final showPassword = useState(false);
    final showConfirmPassword = useState(false);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    // Auth
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final authState = ref.watch(authNotifierProvider);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(
          'تعيين كلمة مرور جديدة',
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
              children: [
                // Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    size: 36,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  'كلمة مرور جديدة',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'أدخل كلمة المرور الجديدة لحسابك',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Error Message
                if (authState.errorMessage != null)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.error.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: colors.error,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            authState.errorMessage!,
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // New Password Field
                _buildLabel('كلمة المرور الجديدة', context),
                const SizedBox(height: 8),
                TextFormField(
                  controller: passwordController,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  obscureText: !showPassword.value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال كلمة المرور الجديدة';
                    }
                    if (value.length < 6) {
                      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'أدخل كلمة المرور الجديدة',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: colors.onSurfaceVariant,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPassword.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: colors.onSurfaceVariant,
                      ),
                      onPressed: () => showPassword.value = !showPassword.value,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                _buildLabel('تأكيد كلمة المرور', context),
                const SizedBox(height: 8),
                TextFormField(
                  controller: confirmPasswordController,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  obscureText: !showConfirmPassword.value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى تأكيد كلمة المرور';
                    }
                    if (value != passwordController.text) {
                      return 'كلمات المرور غير متطابقة';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'أعد إدخال كلمة المرور',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: colors.onSurfaceVariant,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showConfirmPassword.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: colors.onSurfaceVariant,
                      ),
                      onPressed: () => showConfirmPassword.value =
                          !showConfirmPassword.value,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Password Requirements
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colors.outlineVariant.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'متطلبات كلمة المرور:',
                        style: textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildRequirement(
                        '6 أحرف على الأقل',
                        passwordController.text.length >= 6,
                        textTheme,
                        colors,
                      ),
                      _buildRequirement(
                        'كلمات المرور متطابقة',
                        confirmPasswordController.text.isNotEmpty &&
                            passwordController.text ==
                                confirmPasswordController.text,
                        textTheme,
                        colors,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Reset Button
                AsyncButton.primary(
                  label: 'تعيين كلمة المرور',
                  icon: Icons.check,
                  onPressed: () {
                    if (!(formKey.currentState?.validate() ?? false)) {
                      return Future.value(
                        Result.err('يرجى تصحيح الأخطاء في النموذج'),
                      );
                    }

                    final request = ResetPasswordRequestDto(
                      email: email,
                      token: '', // Token from deep link or previous step
                      password: passwordController.text,
                      passwordConfirmation: confirmPasswordController.text,
                    );

                    return authNotifier.resetPassword(request);
                  },
                  loadingMessage: 'جاري تعيين كلمة المرور...',
                  successMessage: 'تم تعيين كلمة المرور بنجاح',
                  onSuccess: () {
                    context.router.replaceAll([const LoginRoute()]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label, BuildContext context) {
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

  Widget _buildRequirement(
    String text,
    bool isMet,
    TextTheme textTheme,
    ColorScheme colors,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isMet ? Colors.green : colors.outline,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: textTheme.bodySmall?.copyWith(
              color: isMet ? Colors.green.shade700 : colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
