import 'package:flutter_test/flutter_test.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_state.dart';

void main() {
  const tItem1 = CartItemEntity(
    itemId: 'item_1',
    productId: 'prod_1',
    productName: 'Red Roses',
    productImage: 'roses.png',
    unitPrice: 50,
    priceAtAdd: 50,
    quantity: 2,
    lineSubtotal: 100,
    availableStock: 10,
    isAvailable: true,
    priceChanged: false,
    stockChanged: false,
  );

  const tItem2 = CartItemEntity(
    itemId: 'item_2',
    productId: 'prod_2',
    productName: 'Tulips',
    productImage: 'tulips.png',
    unitPrice: 30,
    priceAtAdd: 30,
    quantity: 3,
    lineSubtotal: 90,
    availableStock: 5,
    isAvailable: true,
    priceChanged: false,
    stockChanged: false,
  );

  const tCart = CartEntity(
    cartId: 'cart_123',
    items: [tItem1, tItem2],
    totalQuantity: 5,
    lineCount: 2,
    subtotal: 190,
    deliveryFee: 20,
    total: 210,
    hasChanges: false,
  );

  group('CartState Unit Tests', () {
    test('initial state should have default values', () {
      final state = CartState.initial();

      expect(state.cart.isLoading, isFalse);
      expect(state.cart.errorMessage, isNull);
      expect(state.cart.data, isNull);

      expect(state.addingProductId, isNull);
      expect(state.loadingItemId, isNull);
    });

    test('getCartItem returns matching cart item by productId', () {
      final state = CartState(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tCart,
        ),
      );

      expect(state.getCartItem('prod_1'), equals(tItem1));
      expect(state.getCartItem('prod_2'), equals(tItem2));
    });

    test('getCartItem returns null when product does not exist', () {
      final state = CartState(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tCart,
        ),
      );

      expect(state.getCartItem('unknown_product'), isNull);
    });

    test('getQuantity returns correct quantity for existing product', () {
      final state = CartState(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tCart,
        ),
      );

      expect(state.getQuantity('prod_1'), equals(2));
      expect(state.getQuantity('prod_2'), equals(3));
    });

    test('getQuantity returns 0 when product does not exist', () {
      final state = CartState(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tCart,
        ),
      );

      expect(state.getQuantity('unknown_product'), equals(0));
    });

    test('getCartItemId returns correct itemId for product', () {
      final state = CartState(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tCart,
        ),
      );

      expect(state.getCartItemId('prod_1'), equals('item_1'));
      expect(state.getCartItemId('prod_2'), equals('item_2'));
    });

    test('getCartItemId returns null when product does not exist', () {
      final state = CartState(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tCart,
        ),
      );

      expect(state.getCartItemId('unknown_product'), isNull);
    });

    test('isProductLoading returns true for the product whose item is loading', () {
      final state = CartState(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tCart,
        ),
        loadingItemId: 'item_1',
      );

      expect(state.isProductLoading('prod_1'), isTrue);
      expect(state.isProductLoading('prod_2'), isFalse);
    });

    test('isProductLoading returns false when loadingItemId is null', () {
      final state = CartState(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tCart,
        ),
      );

      expect(state.isProductLoading('prod_1'), isFalse);
    });

    test('isProductAdding returns true for matching productId', () {
      final state = CartState(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tCart,
        ),
        addingProductId: 'prod_1',
      );

      expect(state.isProductAdding('prod_1'), isTrue);
      expect(state.isProductAdding('prod_2'), isFalse);
    });

    test('isProductAdding returns false when addingProductId is null', () {
      final state = CartState(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tCart,
        ),
      );

      expect(state.isProductAdding('prod_1'), isFalse);
    });

    test('copyWith should update cart correctly', () {
      final initialState = CartState.initial();

      final updatedState = initialState.copyWith(
        cart: BaseState<CartEntity>(
          isLoading: true,
          errorMessage: null,
          data: tCart,
        ),
      );

      expect(updatedState.cart.isLoading, isTrue);
      expect(updatedState.cart.data, equals(tCart));
    });

    test('copyWith should set addingProductId correctly', () {
      final state = CartState.initial();

      final updatedState = state.copyWith(
        addingProductId: () => 'prod_1',
      );

      expect(updatedState.addingProductId, equals('prod_1'));
      expect(updatedState.isProductAdding('prod_1'), isTrue);
    });

    test('copyWith should clear addingProductId', () {
      final state = CartState(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tCart,
        ),
        addingProductId: 'prod_1',
      );

      final updatedState = state.copyWith(
        addingProductId: () => null,
      );

      expect(updatedState.addingProductId, isNull);
    });

    test('copyWith should set loadingItemId correctly', () {
      final state = CartState.initial();

      final updatedState = state.copyWith(
        loadingItemId: () => 'item_1',
      );

      expect(updatedState.loadingItemId, equals('item_1'));
      expect(updatedState.isProductLoading('prod_1'), isFalse);
    });

    test('copyWith should clear loadingItemId', () {
      final state = CartState(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tCart,
        ),
        loadingItemId: 'item_1',
      );

      final updatedState = state.copyWith(
        loadingItemId: () => null,
      );

      expect(updatedState.loadingItemId, isNull);
    });

    test('states with same properties should be equal', () {
      final stateA = CartState(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tCart,
        ),
        addingProductId: 'prod_1',
        loadingItemId: 'item_1',
      );

      final stateB = CartState(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tCart,
        ),
        addingProductId: 'prod_1',
        loadingItemId: 'item_1',
      );

      expect(stateA, equals(stateB));
    });
  });
}
