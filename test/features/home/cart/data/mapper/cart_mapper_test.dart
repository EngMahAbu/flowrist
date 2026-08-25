import 'package:flutter_test/flutter_test.dart';
import 'package:flowrist/features/home/cart/data/mapper/cart_mapper.dart';
import 'package:flowrist/features/home/cart/data/models/response/cart_response_dto.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';

void main() {
  group('CartMapper Unit Tests', () {
    test(
      'toCartEntity maps fully populated CartResponseDto to CartEntity correctly',
      () {
        const tDto = CartResponseDto(
          message: 'Success',
          data: CartDataDto(
            cartId: 'cart_123',
            total: 150,
            items: [
              CartItemDto(
                itemId: 'item_1',
                productId: 'prod_1',
                productName: 'Red Roses',
                productImage: 'roses.png',
                unitPrice: 50,
                priceAtAdd: 50,
                quantity: 3,
                availableStock: 10,
              ),
            ],
          ),
        );

        final entity = CartMapper.toCartEntity(tDto);

        expect(entity, isA<CartEntity>());
        expect(entity.cartId, equals('cart_123'));
        expect(entity.total, equals(150));
        expect(entity.items.length, equals(1));

        final itemEntity = entity.items.first;
        expect(itemEntity, isA<CartItemEntity>());
        expect(itemEntity.itemId, equals('item_1'));
        expect(itemEntity.productId, equals('prod_1'));
        expect(itemEntity.productName, equals('Red Roses'));
        expect(itemEntity.productImage, equals('roses.png'));
        expect(itemEntity.unitPrice, equals(50));
        expect(itemEntity.priceAtAdd, equals(50));
        expect(itemEntity.quantity, equals(3));
        expect(itemEntity.availableStock, equals(10));
      },
    );

    test(
      'toCartEntity handles null fields gracefully using default fallback values',
      () {
        const tNullDto = CartResponseDto(message: null, data: null);

        final entity = CartMapper.toCartEntity(tNullDto);

        expect(entity.cartId, isEmpty);
        expect(entity.total, equals(0));
        expect(entity.items, isEmpty);
        expect(entity.totalQuantity, equals(0));
      },
    );

    test('toCartEntity handles items with null inner fields', () {
      const tDtoWithNulls = CartResponseDto(
        data: CartDataDto(
          cartId: null,
          total: null,
          items: [
            CartItemDto(
              itemId: null,
              productId: null,
              productName: null,
              productImage: null,
              unitPrice: null,
              priceAtAdd: null,
              quantity: null,
              availableStock: null,
            ),
          ],
        ),
      );

      final entity = CartMapper.toCartEntity(tDtoWithNulls);

      expect(entity.cartId, isEmpty);
      expect(entity.total, equals(0));
      expect(entity.items.length, equals(1));

      final item = entity.items.first;
      expect(item.itemId, isEmpty);
      expect(item.productId, isEmpty);
      expect(item.productName, isEmpty);
      expect(item.productImage, isEmpty);
      expect(item.unitPrice, equals(0));
      expect(item.priceAtAdd, equals(0));
      expect(item.quantity, equals(0));
      expect(item.availableStock, equals(0));
    });
  });
}
