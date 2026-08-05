import 'package:retrofit/retrofit.dart';
import '../../../imports/imports.dart';
import '../../network/api_response.dart';
import 'order_dtos.dart';
import 'shipment_dtos.dart';

part 'shipment_repo.g.dart';

@RestApi(callAdapter: ApiResultAdapter)
abstract class ShipmentRepo {
  factory ShipmentRepo(Dio dio, {String baseUrl}) = _ShipmentRepo;

  @PUT('/v1/shipments/{id}')
  Future<Result<ApiResponse<ShipmentDto>>> updateShipment(
    @Path('id') String id,
    @Body() UpdateShipmentRequest request,
  );

  @PATCH('/v1/shipments/{id}/status')
  Future<Result<ApiResponse<ShipmentDto>>> updateShipmentStatus(
    @Path('id') String id,
    @Body() UpdateShipmentStatusRequest request,
  );

  @GET('/v1/shipments/{id}')
  Future<Result<ApiResponse<ShipmentDetailsDto>>> getShipment(
    @Path('id') String id,
  );

  @GET('/v1/shipments/search')
  Future<Result<ApiResponse<ShipmentsSearchPageDto>>> searchShipments({
    @Query('trackingNumber') String? trackingNumber,
    @Query('status') String? status,
    @Query('page') int page = 1,
    @Query('pageSize') int pageSize = 20,
  });

  @POST('/v1/shipments/{id}/cancel')
  Future<Result<ApiResponse<dynamic>>> cancelShipment(@Path('id') String id);

  @POST('/v1/orders')
  Future<Result<ApiResponse<OrderResultDto>>> createOrder(
    @Body() CreateOrderRequest request,
  );

  @POST('/v1/orders/bulk')
  Future<Result<ApiResponse<BulkCreateOrdersResultDto>>> bulkCreateOrders(
    @Body() BulkCreateOrdersRequest request,
  );
}
