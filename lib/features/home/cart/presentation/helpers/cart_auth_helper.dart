import 'package:flowrist/features/home/cart/presentation/cubit/cart_cubit.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_event.dart';

abstract final class CartAuthHelper {
  static AddToCartEvent? _pendingAddToCartEvent;

  static void setPendingAction(AddToCartEvent event) {
    _pendingAddToCartEvent = event;
  }

  static void executePendingActionIfAny(CartCubit cartCubit) {
    if (_pendingAddToCartEvent != null) {
      cartCubit.doIntent(_pendingAddToCartEvent!);
      _pendingAddToCartEvent = null;
    }
  }
}
