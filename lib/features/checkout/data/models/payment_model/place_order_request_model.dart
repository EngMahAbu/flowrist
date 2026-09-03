import 'package:flowrist/features/checkout/domain/entities/payment_entity/place_order_request_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'place_order_request_model.g.dart';

@JsonSerializable()
class PlaceOrderRequestModel {
  final String cartId;
  final String addressId;
  final bool isGift;
  final String? giftRecipient;
  final String paymentMethod;
  final String? paymentGateway;

  const PlaceOrderRequestModel({
    required this.cartId,
    required this.addressId,
    required this.isGift,
    this.giftRecipient,
    required this.paymentMethod,
    this.paymentGateway,
  });

  factory PlaceOrderRequestModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$PlaceOrderRequestModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PlaceOrderRequestModelToJson(this);

  factory PlaceOrderRequestModel.fromEntity(
    PlaceOrderRequestEntity entity,
  ) {
    return PlaceOrderRequestModel(
      cartId: entity.cartId,
      addressId: entity.addressId,
      isGift: entity.isGift,
      giftRecipient: entity.giftRecipient,
      paymentMethod: entity.paymentMethod,
      paymentGateway: entity.paymentGateway,
    );
  }
}