import '../../app/providers/auth/auth_providers.dart';
import '../../data/network/network.dart';
import '../../data/repositories/auth/models/auth_dtos.dart';
import '../../imports/imports.dart';

@RoutePage()
class ForgotPasswordPage extends HookConsumerWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surfaceContainer,
      appBar: AppBar(
        title: Text(
          'استعادة كلمة المرور',
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
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.lock_reset,
                    size: 36,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'نسيت كلمة المرور؟',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'أدخل بريدك الإلكتروني وسنرسل لك رمز التحقق',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Text(
                  'البريد الإلكتروني',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: emailController,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v?.isEmpty ?? false
                      ? 'يرجى إدخال البريد الإلكتروني'
                      : null,
                  decoration: InputDecoration(
                    hintText: 'أدخل بريدك الإلكتروني',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                AsyncButton.primary(
                  label: 'إرسال رمز التحقق',
                  icon: Icons.send,
                  onPressed: () {
                    if (!(formKey.currentState?.validate() ?? false)) {
                      return Future.value(
                        const Result.err('يرجى إدخال البريد الإلكتروني'),
                      );
                    }
                    final request = ForgotPasswordRequestDto(
                      email: emailController.text.trim(),
                    );
                    return authNotifier.forgotPassword(request);
                  },
                  loadingMessage: 'جاري الإرسال...',
                  successMessage: 'تم إرسال رمز التحقق',
                  onSuccess: () => context.router.push(
                    OtpRoute(email: emailController.text.trim()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
