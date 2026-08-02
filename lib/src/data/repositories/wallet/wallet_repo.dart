import 'package:retrofit/retrofit.dart';
import '../../../imports/imports.dart';
import '../../network/api_response.dart';
import 'wallet_dtos.dart';

part 'wallet_repo.g.dart';

@RestApi(callAdapter: ApiResultAdapter)
abstract class WalletRepo {
  factory WalletRepo(Dio dio, {String baseUrl}) = _WalletRepo;

  /// Get user's wallet balance
  @GET('/v1/wallet/balance')
  Future<Result<ApiResponse<WalletBalanceDto>>> getBalance();

  /// Get wallet dashboard summary
  @GET('/v1/wallet/dashboard')
  Future<Result<ApiResponse<WalletDashboardDto>>> getDashboard();

  /// Get paginated transaction history
  @GET('/v1/wallet/transactions')
  Future<Result<ApiResponse<WalletTransactionsPageDto>>> getTransactions({
    @Query('page') int page = 1,
    @Query('perPage') int perPage = 20,
    @Query('type') String? type,
    @Query('status') String? status,
  });
}
