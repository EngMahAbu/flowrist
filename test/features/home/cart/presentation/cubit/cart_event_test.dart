import 'package:flutter_test/flutter_test.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_event.dart';

void main() {
  const tCartItem = CartItemEntity(
    itemId: 'item_1',
    productId: 'prod_1',
    productName: 'Red Roses',
    productImage: 'roses.png',
    unitPrice: 50,
    priceAtAdd: 50,
    quantity: 1,
    availableStock: 10,
  );

  group('CartEvent Unit Tests', () {
    test('GetCartEvent can be instantiated correctly', () {
      final event = GetCartEvent();
      expect(event, isA<CartEvent>());
    });

    test('AddToCartEvent holds correct properties', () {
      final event = AddToCartEvent(
        productId: 'prod_1',
        optimisticItem: tCartItem,
      );

      expect(event, isA<CartEvent>());
      expect(event.productId, equals('prod_1'));
      expect(event.optimisticItem, equals(tCartItem));
    });

    test('ChangeCartQuantityEvent holds correct productId and delta', () {
      final event = ChangeCartQuantityEvent(productId: 'prod_1', delta: 1);

      expect(event, isA<CartEvent>());
      expect(event.productId, equals('prod_1'));
      expect(event.delta, equals(1));
    });
  });
}
