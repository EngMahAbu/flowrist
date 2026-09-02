import 'package:flowrist/features/checkout/domain/entities/payment_entity/create_checkout_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_checkout_request_model.g.dart';

@JsonSerializable()
class CreateCheckoutRequestModel {
  final String orderId;
  final int amountTotal;
  final String currency;

  const CreateCheckoutRequestModel({
    required this.orderId,
    required this.amountTotal,
    required this.currency,
  });

  factory CreateCheckoutRequestModel.fromEntity(
    CreateCheckoutEntity entity,
  ) {
    return CreateCheckoutRequestModel(
      orderId: entity.orderId,
      amountTotal: entity.amountTotal,
      currency: entity.currency,
    );
  }

  factory CreateCheckoutRequestModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CreateCheckoutRequestModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CreateCheckoutRequestModelToJson(this);
}

