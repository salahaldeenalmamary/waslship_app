// File: lib/features/address/data/address_repo.dart

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../network/network.dart';
import '../auth/models/auth_dtos.dart';
import 'models/address_dtos.dart';

part 'address_repo.g.dart';

@RestApi(callAdapter: ApiResultAdapter)
abstract class AddressRepo {
  factory AddressRepo(Dio dio, {String baseUrl}) = _AddressRepo;

  /// Get the authenticated user's saved addresses
  @GET('/users/addresses')
  Future<Result<AddressListResponseDto>> getUserAddresses();

  /// Get a specific saved address by ID
  @GET('/users/addresses/{addressId}')
  Future<Result<AddressResponseDto>> getUserAddressById(
    @Path('addressId') int addressId,
  );

  /// Create a new address for the authenticated user
  @POST('/users/addresses')
  Future<Result<AddressResponseDto>> addUserAddress(
    @Body() AddAddressRequestDto request,
  );

  /// Update an existing address for the authenticated user
  @PUT('/users/addresses/{addressId}')
  Future<Result<AddressResponseDto>> updateUserAddress(
    @Path('addressId') int addressId,
    @Body() UpdateAddressRequestDto request,
  );

  /// Delete a saved address for the authenticated user
  @DELETE('/users/addresses/{addressId}')
  Future<Result<MessageResponseDto>> deleteUserAddress(
    @Path('addressId') int addressId,
  );

  /// Set an address as the default for the authenticated user
  @PUT('/users/addresses/{addressId}/default')
  Future<Result<AddressResponseDto>> setDefaultUserAddress(
    @Path('addressId') int addressId,
  );
}
