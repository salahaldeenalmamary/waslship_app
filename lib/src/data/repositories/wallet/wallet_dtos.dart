import 'package:json_annotation/json_annotation.dart';

part 'wallet_dtos.g.dart';

// ============================================
// Balance
// ============================================

@JsonSerializable()
class WalletBalanceDto {
  final String userId;
  final double balance;
  @JsonKey(name: 'reservedAmount')
  final double reservedAmount;
  @JsonKey(name: 'availableBalance')
  final double availableBalance;
  final String currency;

  const WalletBalanceDto({
    required this.userId,
    required this.balance,
    required this.reservedAmount,
    required this.availableBalance,
    required this.currency,
  });

  factory WalletBalanceDto.fromJson(Map<String, dynamic> json) =>
      _$WalletBalanceDtoFromJson(json);
  Map<String, dynamic> toJson() => _$WalletBalanceDtoToJson(this);
}

// ============================================
// Transaction
// ============================================

@JsonSerializable()
class WalletTransactionDto {
  final String id;
  @JsonKey(name: 'transactionNumber')
  final String transactionNumber;
  final double amount;
  final String type;
  final String status;
  final String? description;
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @JsonKey(name: 'isCredit')
  final bool isCredit;

  const WalletTransactionDto({
    required this.id,
    required this.transactionNumber,
    required this.amount,
    required this.type,
    required this.status,
    this.description,
    required this.createdAt,
    required this.isCredit,
  });

  factory WalletTransactionDto.fromJson(Map<String, dynamic> json) =>
      _$WalletTransactionDtoFromJson(json);
  Map<String, dynamic> toJson() => _$WalletTransactionDtoToJson(this);
}

// ============================================
// Dashboard
// ============================================

@JsonSerializable()
class WalletDashboardDto {
  final WalletBalanceDto balance;
  @JsonKey(name: 'codPending')
  final double codPending;
  @JsonKey(name: 'activeTransactions')
  final int activeTransactions;
  @JsonKey(name: 'totalIncome')
  final double totalIncome;
  @JsonKey(name: 'recentTransactions')
  final List<WalletTransactionDto> recentTransactions;

  const WalletDashboardDto({
    required this.balance,
    required this.codPending,
    required this.activeTransactions,
    required this.totalIncome,
    required this.recentTransactions,
  });

  factory WalletDashboardDto.fromJson(Map<String, dynamic> json) =>
      _$WalletDashboardDtoFromJson(json);
  Map<String, dynamic> toJson() => _$WalletDashboardDtoToJson(this);
}

// ============================================
// Paginated Transactions
// ============================================

@JsonSerializable()
class WalletTransactionsPageDto {
  final List<WalletTransactionDto> items;
  @JsonKey(name: 'totalCount')
  final int totalCount;
  @JsonKey(name: 'pageNumber')
  final int pageNumber;
  @JsonKey(name: 'pageSize')
  final int pageSize;
  @JsonKey(name: 'totalPages')
  final int totalPages;

  const WalletTransactionsPageDto({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
  });

  factory WalletTransactionsPageDto.fromJson(Map<String, dynamic> json) =>
      _$WalletTransactionsPageDtoFromJson(json);
  Map<String, dynamic> toJson() => _$WalletTransactionsPageDtoToJson(this);

  bool get hasMore => pageNumber < totalPages;
}
