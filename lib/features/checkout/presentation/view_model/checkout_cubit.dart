import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_entity.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_request_entity.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/delivery_fee_entity.dart';
import 'package:flowrist/features/checkout/domain/use_cases/get_delivery_fee_use_case.dart';
import 'package:flowrist/features/checkout/domain/use_cases/place_order_use_case.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CheckoutCubit extends Cubit<CheckoutState> {
  final PlaceOrderUseCase _placeOrderUseCase;
  final GetDeliveryFeeUseCase _getDeliveryFeeUseCase;

  CheckoutCubit(
    this._placeOrderUseCase,
    this._getDeliveryFeeUseCase,
  ) : super(CheckoutState.initial());

  void selectPaymentMethod(String paymentMethod) {
    emit(
      state.copyWith(
        selectedPaymentMethod: paymentMethod,
        placeOrderState:
            BaseState<CardOrderEntity?>.initial(),
      ),
    );
  }

  void updateGiftInfo({
    required bool isGift,
    required String name,
    required String phone,
  }) {
    emit(
      state.copyWith(
        isGift: isGift,
        giftName: name,
        giftPhone: phone,
      ),
    );
  }

  Future<void> placeOrder(
    CardOrderRequestEntity order,
  ) async {
    emit(
      state.copyWith(
        placeOrderState:
            BaseState<CardOrderEntity?>.loading(),
      ),
    );

    try {
      final response = await _placeOrderUseCase(order);

      switch (response) {
        case SuccessResponse<CardOrderEntity?>():
          // IMPORTANT:
          // entity can be null for COD.
          // Null does NOT mean error.
          final entity = response.data;

          debugPrint(
            '========== PLACE ORDER SUCCESS ==========',
          );
          debugPrint('Payment method: ${order.paymentMethod}');
          debugPrint('Has order data: ${entity != null}');
          debugPrint(
            'Order ID: ${entity?.orderId}',
          );
          debugPrint(
            'Session URL: ${entity?.sessionUrl}',
          );
          debugPrint(
            '=========================================',
          );

          emit(
            state.copyWith(
              placeOrderState:
                  BaseState<CardOrderEntity?>.success(
                entity,
              ),
            ),
          );

        case ErrorResponse<CardOrderEntity?>():
          emit(
            state.copyWith(
              placeOrderState:
                  BaseState<CardOrderEntity?>.error(
                response.errorMessage,
              ),
            ),
          );
      }
    } catch (e, stackTrace) {
      debugPrint(
        '========== PLACE ORDER EXCEPTION ==========',
      );
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());

      emit(
        state.copyWith(
          placeOrderState:
              BaseState<CardOrderEntity?>.error(
            e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> getDeliveryFee({
    required String addressId,
    required String cartId,
  }) async {
    emit(
      state.copyWith(
        deliveryFeeState:
            BaseState<DeliveryFeeEntity>.loading(),
      ),
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
                deliveryFeeState:
                    BaseState<DeliveryFeeEntity>.error(
                  'Invalid delivery fee response',
                ),
              ),
            );
            return;
          }

          emit(
            state.copyWith(
              deliveryFeeState:
                  BaseState<DeliveryFeeEntity>.success(
                entity,
              ),
            ),
          );

        case ErrorResponse<DeliveryFeeEntity>():
          emit(
            state.copyWith(
              deliveryFeeState:
                  BaseState<DeliveryFeeEntity>.error(
                response.errorMessage,
              ),
            ),
          );
      }
    } catch (e, stackTrace) {
      debugPrint(
        '========== DELIVERY FEE EXCEPTION ==========',
      );
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());

      emit(
        state.copyWith(
          deliveryFeeState:
              BaseState<DeliveryFeeEntity>.error(
            e.toString(),
          ),
        ),
      );
    }
  }

  void reset() {
    emit(CheckoutState.initial());
  }
}