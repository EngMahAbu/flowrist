import 'package:dio/dio.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/features/home/shared/home_address/data/model/address_model/address_api_response_model.dart';
import 'package:flowrist/features/home/shared/home_address/data/model/address_model/set_default_address_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
part 'home_address_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class HomeAddressApiClient {
  @factoryMethod
  factory HomeAddressApiClient(Dio dio) = _HomeAddressApiClient;

  @GET(Endpoints.getAllAddress)
  Future<AddressApiResponseModel> getAllUserAddresses();

  @PATCH(Endpoints.setDefaultAddress)
  Future<SetDefaultAddressResponseModel> setDefaultAddress(
    @Path('addressId') String addressId,
  );
}
