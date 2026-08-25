import 'package:flutter_test/flutter_test.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';

void main() {
  const tCartItem = CartItemEntity(
    itemId: 'item_1',
    productId: 'prod_1',
    productName: 'Red Roses',
    productImage: 'roses.png',
    unitPrice: 50,
    priceAtAdd: 50,
    quantity: 2,
    availableStock: 10,
  );

  group('CartItemEntity Unit Tests', () {
    test(
      'copyWith should update quantity correctly while preserving all other properties',
      () {
        final updatedItem = tCartItem.copyWith(quantity: 5);

        expect(updatedItem.quantity, equals(5));
        expect(updatedItem.itemId, equals(tCartItem.itemId));
        expect(updatedItem.productId, equals(tCartItem.productId));
        expect(updatedItem.productName, equals(tCartItem.productName));
        expect(updatedItem.productImage, equals(tCartItem.productImage));
        expect(updatedItem.unitPrice, equals(tCartItem.unitPrice));
        expect(updatedItem.priceAtAdd, equals(tCartItem.priceAtAdd));
        expect(updatedItem.availableStock, equals(tCartItem.availableStock));
      },
    );

    test('copyWith with null parameter should return identical values', () {
      final unchangedItem = tCartItem.copyWith();

      expect(unchangedItem.quantity, equals(tCartItem.quantity));
      expect(unchangedItem, equals(tCartItem));
    });

    test(
      'props equality should match when itemId, productId, and quantity are identical',
      () {
        const itemWithSameKeyProps = CartItemEntity(
          itemId: 'item_1',
          productId: 'prod_1',
          productName: 'Different Name',
          productImage: 'different_image.png',
          unitPrice: 100,
          priceAtAdd: 100,
          quantity: 2,
          availableStock: 20,
        );

        expect(tCartItem, equals(itemWithSameKeyProps));
      },
    );

    test('props equality should not match when quantity is different', () {
      final differentQuantityItem = tCartItem.copyWith(quantity: 3);

      expect(tCartItem, isNot(equals(differentQuantityItem)));
    });
  });
}
