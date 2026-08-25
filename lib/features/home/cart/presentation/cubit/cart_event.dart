import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';

sealed class CartEvent {}

class GetCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final String productId;
  final CartItemEntity optimisticItem;

  AddToCartEvent({required this.productId, required this.optimisticItem});
}

class ChangeCartQuantityEvent extends CartEvent {
  final String productId;
  final int delta;

  ChangeCartQuantityEvent({required this.productId, required this.delta});
}
