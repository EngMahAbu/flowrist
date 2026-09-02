import 'package:dio/dio.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/create_checkout_request_model.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/create_checkout_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'checkout_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class CheckoutApiClient {
  @factoryMethod
  factory CheckoutApiClient(Dio dio) = _CheckoutApiClient;

  @POST(Endpoints.createCheckOut)
  Future<CreateCheckoutResponseModel> createCheckout(
    @Body() CreateCheckoutRequestModel request,
  );
}
