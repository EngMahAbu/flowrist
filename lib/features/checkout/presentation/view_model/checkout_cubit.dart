import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/checkout_session_entity.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/create_checkout_entity.dart';
import 'package:flowrist/features/checkout/domain/use_cases/create_checkout_use_case.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class CheckoutCubit extends Cubit<CheckoutState> {
  final CreateCheckoutUseCase _createCheckoutUseCase;

  CheckoutCubit(this._createCheckoutUseCase)
      : super(CheckoutState.initial());

  void selectPaymentMethod(String paymentMethod) {
    emit(
      state.copyWith(
        selectedPaymentMethod: paymentMethod,
      ),
    );
  }

  Future<void> createCheckout(
    CreateCheckoutEntity checkout,
  ) async {
    emit(
      state.copyWith(
      createCheckoutState: state.createCheckoutState.copyWith(
          isLoading: true,
          errorMessage: null,
          data: null
        ),
      ),
    );

    final response = await _createCheckoutUseCase(checkout);

    switch (response) {
      case SuccessResponse<CheckoutSessionEntity>():
        emit(
          state.copyWith(
            createCheckoutState: state.createCheckoutState.copyWith(
              isLoading: false,
              errorMessage: null,
              data: response.data,
            ),
          ),
        );

      case ErrorResponse<CheckoutSessionEntity>():
        emit(
          state.copyWith(
      createCheckoutState: state.createCheckoutState.copyWith(
          isLoading: false,
          errorMessage: response.errorMessage,
          data: null
        ),
          ),
        );
    }
  }
}
 
