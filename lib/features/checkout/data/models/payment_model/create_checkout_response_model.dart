 
import 'package:flowrist/features/checkout/domain/entities/payment_entity/checkout_session_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_checkout_response_model.g.dart';

@JsonSerializable()
class CreateCheckoutResponseModel {
  final CheckoutValueModel? value;
  final bool? isSuccess;
  final bool? isFailure;
  final CheckoutErrorModel? error;

  const CreateCheckoutResponseModel({
    this.value,
    this.isSuccess,
    this.isFailure,
    this.error,
  });

  factory CreateCheckoutResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CreateCheckoutResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CreateCheckoutResponseModelToJson(this);

  CheckoutSessionEntity? toEntity() {
    return value?.toEntity();
  }
}

@JsonSerializable()
class CheckoutValueModel {
  final String? checkoutUrl;
  final String? stripeSessionId;
  final String? paymentAttemptId;

  const CheckoutValueModel({
    this.checkoutUrl,
    this.stripeSessionId,
    this.paymentAttemptId,
  });

  factory CheckoutValueModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CheckoutValueModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CheckoutValueModelToJson(this);

  CheckoutSessionEntity toEntity() {
    return CheckoutSessionEntity(
      checkoutUrl: checkoutUrl ?? '',
      stripeSessionId: stripeSessionId ?? '',
      paymentAttemptId: paymentAttemptId ?? '',
    );
  }
}

@JsonSerializable()
class CheckoutErrorModel {
  final String? code;
  final String? message;

  const CheckoutErrorModel({
    this.code,
    this.message,
  });

  factory CheckoutErrorModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CheckoutErrorModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CheckoutErrorModelToJson(this);
}
 
