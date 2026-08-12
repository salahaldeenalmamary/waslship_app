import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../network/call_adapter.dart';
import '../../network/result.dart';
import 'carrier_dtos.dart';

part 'carrier_repo.g.dart';

@RestApi(callAdapter: ApiResultAdapter)
abstract class CarrierRepo {
  factory CarrierRepo(Dio dio, {String baseUrl}) = _CarrierRepo;

  /// Verifies whether a specific city/address is serviced by OTO.
  @POST('/api/v1/carrier/verify-address')
  Future<Result<VerifyAddressResponse>> verifyAddress(
    @Body() VerifyAddressRequest request,
  );

  /// Fetches available carrier delivery options and prices for a specific order.
  @POST('/api/v1/carrier/delivery-fee-details')
  Future<Result<DeliveryFeeDetailsResponse>> getDeliveryFeeDetails(
    @Body() DeliveryFeeDetailsRequest request,
  );



  /// Retrieves a paginated list of supported cities.
  @GET('/api/v1/carrier/cities')
  Future<Result<GetCitiesResponse>> getAllCities({
    @Query('country') String country = 'SA',
    @Query('perPage') int perPage = 400,
    @Query('page') int page = 1,
  });
}
