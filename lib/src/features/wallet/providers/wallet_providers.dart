import '../../../app/providers/dio_provider.dart';
import '../../../data/repositories/wallet/wallet_repo.dart';
import '../../../imports/imports.dart';
import 'wallet_notifier.dart';
import 'wallet_state.dart';

final walletRepoProvider = Provider<WalletRepo>((ref) {
  final dio = ref.watch(dioProvider);
  return WalletRepo(dio);
});

final walletNotifierProvider =
    NotifierProvider.autoDispose<WalletNotifier, WalletState>(
      () => WalletNotifier(),
    );
