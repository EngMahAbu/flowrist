import 'package:equatable/equatable.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';

class CartState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final CartEntity? cart;

  const CartState({this.isLoading = false, this.errorMessage, this.cart});

  List<CartItemEntity> get items => cart?.items ?? const [];

  Map<String, int> get productQuantityMap => {
    for (final item in items) item.productId: item.quantity,
  };

  int get totalQuantity => cart?.totalQuantity ?? 0;

  int getQuantity(String productId) => productQuantityMap[productId] ?? 0;

  CartItemEntity? getItemByProductId(String productId) {
    try {
      return items.firstWhere((element) => element.productId == productId);
    } catch (_) {
      return null;
    }
  }

  CartState copyWith({
    bool? isLoading,
    String? errorMessage,
    CartEntity? cart,
  }) {
    return CartState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      cart: cart ?? this.cart,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, cart];
}
