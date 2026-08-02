import '../../../data/repositories/wallet/wallet_repo.dart';
import '../../../imports/imports.dart';
import 'wallet_state.dart';

class WalletNotifier extends StateNotifier<WalletState> {
  final WalletRepo _repo;

  WalletNotifier(this._repo) : super(const WalletState());

  // ── Dashboard ───────────────────────────────────────────────────

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoadingDashboard: true, clearError: true);

    final result = await _repo.getDashboard();

    result.fold(
      onOk: (response) {
        state = state.copyWith(
          isLoadingDashboard: false,
          dashboard: response.data,
        );
      },
      onErr: (message, _) {
        state = state.copyWith(
          isLoadingDashboard: false,
          errorMessage: message,
        );
      },
    );
  }

  // ── Transactions (paginated) ────────────────────────────────────

  Future<void> loadTransactions({
    bool refresh = false,
    String? type,
    String? status,
  }) async {
    if (state.isLoadingTransactions) return;
    if (!refresh && !state.hasMore) return;

    final page = refresh ? 1 : state.currentPage;

    state = state.copyWith(isLoadingTransactions: true);

    final result = await _repo.getTransactions(
      page: page,
      perPage: 20,
      type: type,
      status: status,
    );

    result.fold(
      onOk: (response) {
        final page = response.data;
        if (page == null) return;

        final updated = refresh
            ? page.items
            : [...state.transactions, ...page.items];

        state = state.copyWith(
          isLoadingTransactions: false,
          transactions: updated,
          currentPage: page.pageNumber + 1,
          hasMore: page.hasMore,
        );
      },
      onErr: (message, _) {
        state = state.copyWith(
          isLoadingTransactions: false,
          errorMessage: message,
        );
      },
    );
  }

  Future<void> refresh() async {
    await Future.wait([loadDashboard(), loadTransactions(refresh: true)]);
  }
}
