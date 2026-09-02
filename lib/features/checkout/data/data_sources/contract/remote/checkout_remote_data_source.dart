import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/create_checkout_request_model.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/create_checkout_response_model.dart';

abstract class CheckoutRemoteDataSource {
  Future<BaseResponse<CreateCheckoutResponseModel>> createCheckout(
    CreateCheckoutRequestModel request,
  );
}