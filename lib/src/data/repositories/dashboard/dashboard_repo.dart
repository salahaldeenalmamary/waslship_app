import 'package:retrofit/retrofit.dart';
import '../../../imports/imports.dart';
import '../../network/api_response.dart';
import 'dashboard_dtos.dart';

part 'dashboard_repo.g.dart';

@RestApi(callAdapter: ApiResultAdapter)
abstract class DashboardRepo {
  factory DashboardRepo(Dio dio, {String baseUrl}) = _DashboardRepo;

  @GET('/v1/dashboard/overview')
  Future<Result<ApiResponse<DashboardOverviewDto>>> getDashboardOverview();
}
