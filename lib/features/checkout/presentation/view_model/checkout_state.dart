import 'package:equatable/equatable.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/checkout_session_entity.dart';

class CheckoutState extends Equatable {
  final BaseState<CheckoutSessionEntity> createCheckoutState;
  final String selectedPaymentMethod;

  const CheckoutState({
    required this.createCheckoutState,
    required this.selectedPaymentMethod,
  });

  factory CheckoutState.initial() {
    return CheckoutState(
      createCheckoutState: BaseState.initial(),
      selectedPaymentMethod: 'cash',
    );
  }

  CheckoutState copyWith({
    BaseState<CheckoutSessionEntity>? createCheckoutState,
    String? selectedPaymentMethod,
  }) {
    return CheckoutState(
      createCheckoutState:
          createCheckoutState ?? this.createCheckoutState,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
    );
  }

  @override
  List<Object?> get props => [
        createCheckoutState,
        selectedPaymentMethod,
      ];
}
 