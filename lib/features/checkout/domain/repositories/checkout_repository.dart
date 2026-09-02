import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/checkout_session_entity.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/create_checkout_entity.dart';

abstract class CheckoutRepository {
  Future<BaseResponse<CheckoutSessionEntity>> createCheckout(
    CreateCheckoutEntity checkout,
  );
}
