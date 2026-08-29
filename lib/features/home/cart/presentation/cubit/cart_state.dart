import 'package:equatable/equatable.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';

class CartState extends Equatable {
  final BaseState<CartEntity> cart;
  final String? addingProductId;
  final String? loadingItemId;

  const CartState({
    required this.cart,
    this.addingProductId,
    this.loadingItemId,
  });

  CartState.initial()
    : this(
        cart: BaseState.initial(),
        addingProductId: null,
        loadingItemId: null,
      );

  CartState copyWith({
    BaseState<CartEntity>? cart,
    String? Function()? addingProductId,
    String? Function()? loadingItemId,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      addingProductId: addingProductId != null
          ? addingProductId()
          : this.addingProductId,
      loadingItemId: loadingItemId != null
          ? loadingItemId()
          : this.loadingItemId,
    );
  }

  CartItemEntity? getCartItem(String productId) {
    final cartData = cart.data;
    if (cartData == null) return null;
    try {
      return cartData.items.firstWhere((item) => item.productId == productId);
    } catch (_) {
      return null;
    }
  }

  int getQuantity(String productId) {
    return getCartItem(productId)?.quantity ?? 0;
  }

  String? getCartItemId(String productId) {
    return getCartItem(productId)?.itemId;
  }

  bool isProductLoading(String productId) {
    final itemId = getCartItemId(productId);
    return itemId != null && loadingItemId == itemId;
  }

  bool isProductAdding(String productId) {
    return addingProductId == productId;
  }

  @override
  List<Object?> get props => [cart, addingProductId, loadingItemId];
}
