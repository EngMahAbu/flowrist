import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/checkout_session_entity.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/create_checkout_entity.dart';
import 'package:flowrist/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:injectable/injectable.dart';
@injectable
class CreateCheckoutUseCase {
  final CheckoutRepository _repository;

  CreateCheckoutUseCase(this._repository);

  Future<BaseResponse<CheckoutSessionEntity>> call(
    CreateCheckoutEntity checkout,
  ) {
    return _repository.createCheckout(checkout);
  }
}

