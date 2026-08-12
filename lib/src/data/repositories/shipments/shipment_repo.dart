import 'package:retrofit/retrofit.dart';
import '../../../imports/imports.dart';
import '../../network/api_response.dart';
import 'order_dtos.dart';
import 'shipment_dtos.dart';

part 'shipment_repo.g.dart';

@RestApi(callAdapter: ApiResultAdapter)
abstract class ShipmentRepo {
  factory ShipmentRepo(Dio dio, {String baseUrl}) = _ShipmentRepo;

  // ─── Orders ───────────────────────────────────────────────────────────────

  /// Creates a new shipping order with address enrichment.
  @POST('/api/v1/shipments/orders')
  Future<Result<ApiResponse<OrderResultDto>>> createOrder(
    @Body() CreateOrderRequest request,
  );

  /// Creates multiple orders in a single request.
  @POST('/api/v1/shipments/orders/bulk')
  Future<Result<ApiResponse<BulkCreateOrdersResultDto>>> bulkCreateOrders(
    @Body() BulkCreateOrdersRequest request,
  );

  /// Updates order details on OTO.
  @PUT('/api/v1/shipments/orders/{orderId}')
  Future<Result<ApiResponse<dynamic>>> updateOrder(
    @Path('orderId') String orderId,
    @Body() UpdateOrderRequest request,
  );

  /// Updates the status of an existing order.
  @PATCH('/api/v1/shipments/orders/{orderId}/status')
  Future<Result<ApiResponse<dynamic>>> updateOrderStatus(
    @Path('orderId') String orderId,
    @Body() UpdateOrderStatusRequest request,
  );

  // ─── Shipments ────────────────────────────────────────────────────────────

  /// Triggers shipment generation for an existing OTO order.
  @POST('/api/v1/shipments')
  Future<Result<ApiResponse<dynamic>>> createShipment(
    @Body() TriggerShipmentRequest request,
  );

  /// Retrieves all shipments belonging to the authenticated merchant.
  @GET('/api/v1/shipments')
  Future<Result<ApiResponse<List<ShipmentDto>>>> listShipments();

  /// Searches shipments with filter query parameters and pagination.
  @GET('/api/v1/shipments/search')
  Future<Result<ApiResponse<ShipmentsSearchPageDto>>> searchShipments({
    @Query('trackingNumber') String? trackingNumber,
    @Query('status') String? status,
    @Query('page') int page = 1,
    @Query('pageSize') int pageSize = 20,
  });

  /// Retrieves detailed information for a specific shipment.
  @GET('/api/v1/shipments/{id}')
  Future<Result<ApiResponse<ShipmentDetailsDto>>> getShipment(
    @Path('id') String id,
  );

  /// Modifies local shipment information.
  @PUT('/api/v1/shipments/{id}')
  Future<Result<ApiResponse<dynamic>>> updateShipment(
    @Path('id') String id,
    @Body() UpdateShipmentRequest request,
  );

  /// Updates internal shipment status.
  @PATCH('/api/v1/shipments/{id}/status')
  Future<Result<ApiResponse<dynamic>>> updateShipmentStatus(
    @Path('id') String id,
    @Body() UpdateShipmentStatusRequest request,
  );

  /// Puts a shipment on hold.
  @POST('/api/v1/shipments/{id}/hold')
  Future<Result<ApiResponse<dynamic>>> holdShipment(@Path('id') String id);

  /// Releases an on-hold shipment.
  @POST('/api/v1/shipments/{id}/unhold')
  Future<Result<ApiResponse<dynamic>>> unholdShipment(@Path('id') String id);

  /// Cancels an active shipment/order on OTO and local database.
  @POST('/api/v1/shipments/{orderId}/cancel')
  Future<Result<ApiResponse<dynamic>>> cancelShipment(
    @Path('orderId') String orderId, {
    @Query('shipmentId') String? shipmentId,
  });
}
