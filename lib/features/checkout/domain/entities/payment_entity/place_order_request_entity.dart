import 'package:equatable/equatable.dart';

class PlaceOrderRequestEntity extends Equatable {
  final String cartId;
  final String addressId;
  final bool isGift;
  final String? giftRecipient;
  final String paymentMethod;
  final String? paymentGateway;

  const PlaceOrderRequestEntity({
    required this.cartId,
    required this.addressId,
    required this.isGift,
    this.giftRecipient,
    required this.paymentMethod,
    this.paymentGateway,
  });

  @override
  List<Object?> get props => [
        cartId,
        addressId,
        isGift,
        giftRecipient,
        paymentMethod,
        paymentGateway,
      ];
}