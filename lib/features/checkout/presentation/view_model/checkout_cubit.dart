import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_entity.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_request_entity.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/delivery_fee_entity.dart';
import 'package:flowrist/features/checkout/domain/use_cases/get_delivery_fee_use_case.dart';
import 'package:flowrist/features/checkout/domain/use_cases/place_order_use_case.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_event.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CheckoutCubit extends Cubit<CheckoutState> {
  final PlaceOrderUseCase _placeOrderUseCase;
  final GetDeliveryFeeUseCase _getDeliveryFeeUseCase;

  CheckoutCubit(this._placeOrderUseCase, this._getDeliveryFeeUseCase)
    : super(CheckoutState.initial());
  Future<void> doEvent(CheckoutEvent event) async {
    switch (event) {
      case SelectPaymentMethod():
        _selectPaymentMethod(event.paymentMethod);
      case PlaceOrder():
        _placeOrder(event.order);
      case GetDeliveryFee():
        _getDeliveryFee(addressId: event.addressId, cartId: event.cartId);
      case UpdateGiftInfo():
        _updateGiftInfo(
          isGift: event.isGift,
          name: event.name,
          phone: event.phone,
        );
    }
  }

  void _selectPaymentMethod(String paymentMethod) {
    emit(
      state.copyWith(
        selectedPaymentMethod: paymentMethod,
        placeOrderState: BaseState<CardOrderEntity?>.initial(),
      ),
    );
  }

  void _updateGiftInfo({
    required bool isGift,
    required String name,
    required String phone,
  }) {
    emit(state.copyWith(isGift: isGift, giftName: name, giftPhone: phone));
  }

  Future<void> _placeOrder(CardOrderRequestEntity order) async {
    emit(
      state.copyWith(placeOrderState: BaseState<CardOrderEntity?>.loading()),
    );

    try {
      final response = await _placeOrderUseCase(order);

      switch (response) {
        case SuccessResponse<CardOrderEntity?>():
          final entity = response.data;
          emit(
            state.copyWith(
              placeOrderState: BaseState<CardOrderEntity?>.success(entity),
            ),
          );

        case ErrorResponse<CardOrderEntity?>():
          emit(
            state.copyWith(
              placeOrderState: BaseState<CardOrderEntity?>.error(
                response.errorMessage,
              ),
            ),
          );
      }
    } catch (e) {
      emit(
        state.copyWith(
          placeOrderState: BaseState<CardOrderEntity?>.error(e.toString()),
        ),
      );
    }
  }

  Future<void> _getDeliveryFee({
    required String addressId,
    required String cartId,
  }) async {
    emit(
      state.copyWith(deliveryFeeState: BaseState<DeliveryFeeEntity>.loading()),
    );

    try {
      final response = await _getDeliveryFeeUseCase(
        addressId: addressId,
        cartId: cartId,
      );

      switch (response) {
        case SuccessResponse<DeliveryFeeEntity>():
          final entity = response.data;

          if (entity == null) {
            emit(
              state.copyWith(
                deliveryFeeState: BaseState<DeliveryFeeEntity>.error(
                  'Invalid delivery fee response',
                ),
              ),
            );
            return;
          }

          emit(
            state.copyWith(
              deliveryFeeState: BaseState<DeliveryFeeEntity>.success(entity),
            ),
          );

        case ErrorResponse<DeliveryFeeEntity>():
          emit(
            state.copyWith(
              deliveryFeeState: BaseState<DeliveryFeeEntity>.error(
                response.errorMessage,
              ),
            ),
          );
      }
    } catch (e) {
      emit(
        state.copyWith(
          deliveryFeeState: BaseState<DeliveryFeeEntity>.error(e.toString()),
        ),
      );
    }
  }

  void reset() {
    emit(CheckoutState.initial());
  }
}
