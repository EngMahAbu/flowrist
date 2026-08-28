import 'package:dio/dio.dart';
import 'package:flowrist/config/api_error_handler/api_error_handler.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/shared/home_address/data/client/home_address_api_client.dart';
import 'package:flowrist/features/home/shared/home_address/data/data_sources/contract/remote/set_default_address_data_source.dart';
import 'package:flowrist/features/home/shared/home_address/data/model/address_model/default_address_response_model.dart';
import 'package:injectable/injectable.dart';
@LazySingleton(as: SetDefaultAddressDataSource)
class SetDefaultAddressDataSourceImpl
    implements SetDefaultAddressDataSource {
  final HomeAddressApiClient _apiClient;

  SetDefaultAddressDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<DefaultAddressResponseModel>> setDefaultAddress(
    String addressId,
  ) async {
    try {
      final response = await _apiClient.setDefaultAddress(addressId);

      if (response.status && response.data != null) {
        return SuccessResponse<DefaultAddressResponseModel>(
          response.data!,
        );
      }

      return ErrorResponse<DefaultAddressResponseModel>(
        response.message,
      );
    } on DioException catch (e) {
      return ApiErrorHandler.handleException(e);
    }
  }
}