import '../../../app/providers/dio_provider.dart';
import '../../../data/repositories/payment/payment_repo.dart';
import '../../../imports/imports.dart';
import 'payment_notifier.dart';
import 'payment_state.dart';

// ============================================
// Payment Repo Provider
// ============================================
final paymentRepoProvider = Provider<PaymentRepo>((ref) {
  final dio = ref.watch(dioProvider);
  return PaymentRepo(dio);
});

// ============================================
// Payment Notifier Provider (MAIN PROVIDER)
// ============================================
final paymentNotifierProvider =
    StateNotifierProvider.autoDispose<PaymentNotifier, PaymentState>((ref) {
  final paymentRepo = ref.watch(paymentRepoProvider);
  return PaymentNotifier(paymentRepo);
});
