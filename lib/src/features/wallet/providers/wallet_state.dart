import '../../../data/repositories/wallet/wallet_dtos.dart';

class WalletState {
  final bool isLoadingDashboard;
  final bool isLoadingTransactions;
  final WalletDashboardDto? dashboard;
  final List<WalletTransactionDto> transactions;
  final int currentPage;
  final bool hasMore;
  final String? errorMessage;

  const WalletState({
    this.isLoadingDashboard = false,
    this.isLoadingTransactions = false,
    this.dashboard = null,
    this.transactions = const [],
    this.currentPage = 1,
    this.hasMore = true,
    this.errorMessage = null,
  });

  WalletState copyWith({
    bool? isLoadingDashboard,
    bool? isLoadingTransactions,
    WalletDashboardDto? dashboard,
    List<WalletTransactionDto>? transactions,
    int? currentPage,
    bool? hasMore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return WalletState(
      isLoadingDashboard: isLoadingDashboard ?? this.isLoadingDashboard,
      isLoadingTransactions:
          isLoadingTransactions ?? this.isLoadingTransactions,
      dashboard: dashboard ?? this.dashboard,
      transactions: transactions ?? this.transactions,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  // ── Derived getters ─────────────────────────────────────────────
  double get availableBalance => dashboard?.balance.availableBalance ?? 0.0;
  double get codPending => dashboard?.codPending ?? 0.0;
  int get activeTransactions => dashboard?.activeTransactions ?? 0;
  double get totalIncome => dashboard?.totalIncome ?? 0.0;
  String get currency => dashboard?.balance.currency ?? 'SAR';
  List<WalletTransactionDto> get recentTransactions =>
      dashboard?.recentTransactions ?? [];
}
