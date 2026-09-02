import 'package:flowrist/config/api_error_handler/api_error_handler.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/checkout/data/client/checkout_api_client.dart';
import 'package:flowrist/features/checkout/data/data_sources/contract/remote/checkout_remote_data_source.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/create_checkout_request_model.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/create_checkout_response_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CheckoutRemoteDataSource)
class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  final CheckoutApiClient _apiClient;

  CheckoutRemoteDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<CreateCheckoutResponseModel>> createCheckout(CreateCheckoutRequestModel request) async{
    try {
      final response = await _apiClient.createCheckout(request);
      return SuccessResponse(response);
      
    }on Exception catch (e) {
      return ApiErrorHandler.handleException(e);
    }
  }

   
}
