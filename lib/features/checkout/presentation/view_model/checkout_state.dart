import 'package:equatable/equatable.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_entity.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/delivery_fee_entity.dart';

class CheckoutState extends Equatable {
  final BaseState<CardOrderEntity?> placeOrderState;
  final BaseState<DeliveryFeeEntity> deliveryFeeState;

  final String? selectedPaymentMethod;

  final bool isGift;
  final String giftName;
  final String giftPhone;

  const CheckoutState({
    required this.placeOrderState,
    required this.deliveryFeeState,
    required this.selectedPaymentMethod,
    required this.isGift,
    required this.giftName,
    required this.giftPhone,
  });

  factory CheckoutState.initial() {
    return const CheckoutState(
      placeOrderState: BaseState.initial(),
      deliveryFeeState: BaseState.initial(),
      selectedPaymentMethod: null,
      isGift: false,
      giftName: '',
      giftPhone: '',
    );
  }

  CheckoutState copyWith({
    BaseState<CardOrderEntity?>? placeOrderState,
    BaseState<DeliveryFeeEntity>? deliveryFeeState,
    String? selectedPaymentMethod,
    bool? isGift,
    String? giftName,
    String? giftPhone,
  }) {
    return CheckoutState(
      placeOrderState:
          placeOrderState ?? this.placeOrderState,
      deliveryFeeState:
          deliveryFeeState ?? this.deliveryFeeState,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      isGift: isGift ?? this.isGift,
      giftName: giftName ?? this.giftName,
      giftPhone: giftPhone ?? this.giftPhone,
    );
  }

  @override
  List<Object?> get props => [
        placeOrderState,
        deliveryFeeState,
        selectedPaymentMethod,
        isGift,
        giftName,
        giftPhone,
      ];
}