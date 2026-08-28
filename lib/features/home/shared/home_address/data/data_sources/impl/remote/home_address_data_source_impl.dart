import 'package:flowrist/config/api_error_handler/api_error_handler.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/shared/home_address/data/client/home_address_api_client.dart';
import 'package:flowrist/features/home/shared/home_address/data/data_sources/contract/remote/home_address_data_source.dart';
import 'package:flowrist/features/home/shared/home_address/data/model/address_model/address_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AddressRemoteDataSource)
class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final HomeAddressApiClient _apiClient;

  AddressRemoteDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<List<AddressModel>>> getAllUserAddresses() async {
    try {
      final response = await _apiClient.getAllUserAddresses();

      return SuccessResponse(response.data ?? []);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<List<AddressModel>>(e);
    }
  }
}
