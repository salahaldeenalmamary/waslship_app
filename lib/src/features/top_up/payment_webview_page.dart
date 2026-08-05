import 'package:webview_flutter/webview_flutter.dart';
import '../../data/repositories/payment/payment_dtos.dart';
import '../../imports/imports.dart';
import '../widgets/elite_top_bar.dart';
import 'providers/payment_notifier.dart';

@RoutePage()
class PaymentWebViewPage extends HookConsumerWidget {
  final String url;
  final String depositId;
  final double amount;

  const PaymentWebViewPage({
    super.key,
    required this.url,
    required this.depositId,
    required this.amount,
  });

  // ───────────────────────────────────────────────────────────────
  // Intercept URLs to detect success / cancel from the gateway.

  // ───────────────────────────────────────────────────────────────
  static bool _isSuccessUrl(String url) {
    final lower = url.toLowerCase();
    return lower.contains('payment/success') ||
        lower.contains('paymentcallback') ||
        lower.contains('success') && lower.contains('invoiceid');
  }

  static bool _isCancelUrl(String url) {
    final lower = url.toLowerCase();
    return lower.contains('payment/cancel') ||
        lower.contains('payment/error') ||
        lower.contains('paymentfailed') ||
        lower.contains('cancel');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentNotifier = ref.read(paymentNotifierProvider.notifier);
    final loadingProgress = useState<int>(0);
    final isVerifying = useState(false);

    final controller = useMemoized(() {
      final wc = WebViewController();
      wc
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.transparent)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (progress) {
              loadingProgress.value = progress;
            },
            onPageStarted: (_) {
              loadingProgress.value = 0;
            },
            onPageFinished: (_) {
              loadingProgress.value = 100;
            },
            onNavigationRequest: (request) {
              final reqUrl = request.url;

              if (_isSuccessUrl(reqUrl) && !isVerifying.value) {
                isVerifying.value = true;
                _onPaymentSuccess(
                  context,
                  ref,
                  paymentNotifier,
                  depositId,
                  amount,
                );
                return NavigationDecision.prevent;
              }

              if (_isCancelUrl(reqUrl)) {
                AppToast.warning(
                  context,
                  message: 'تم إلغاء العملية',
                  title: 'ملاحظة',
                );
                context.router.maybePop();
                return NavigationDecision.prevent;
              }

              return NavigationDecision.navigate;
            },
            onWebResourceError: (error) {
              // Ignore cancelled-navigation errors (triggered by our intercept)
              if (error.errorCode == -1) return;
              AppToast.error(context, message: 'فشل تحميل صفحة الدفع');
            },
          ),
        )
        ..loadRequest(Uri.parse(url));
      return wc;
    }, []);

    return Scaffold(
      appBar: EliteTopBar(
        title: 'بوابة الدفع',
        showBack: true,
        onBack: () {
          AppToast.warning(
            context,
            message: 'هل تريد إلغاء عملية الدفع؟',
            title: 'تحذير',
          );
          context.router.maybePop();
        },
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),

          if (loadingProgress.value < 100)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                value: loadingProgress.value / 100.0,
                minHeight: 3,
              ),
            ),

          if (isVerifying.value)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'جاري التحقق من الدفع...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _onPaymentSuccess(
    BuildContext context,
    WidgetRef ref,
    PaymentNotifier notifier,
    String depositId,
    double amount,
  ) async {
    final request = VerifyPaymentRequestDto(depositId: depositId);
    final result = await notifier.verifyPayment(request);

    if (!context.mounted) return;

    result.fold(
      onOk: (response) {
        context.router.replaceAll([
          TopUpSuccessRoute(
            depositId: depositId,
            amount: amount,
            transactionId: response?.transactionId,
          ),
        ]);
      },
      onErr: (message, _) {
        AppToast.error(context, message: message);
        context.router.maybePop();
      },
    );
  }
}
