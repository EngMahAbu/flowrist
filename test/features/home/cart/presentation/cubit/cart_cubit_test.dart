import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/add_to_cart_use_case.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/get_cart_use_case.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/remove_cart_item_use_case.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/update_cart_quantity_use_case.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_cubit.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_event.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_state.dart';
import 'cart_cubit_test.mocks.dart';

@GenerateMocks([
  GetCartUseCase,
  AddToCartUseCase,
  UpdateCartQuantityUseCase,
  RemoveCartItemUseCase,
])
void main() {
  late MockGetCartUseCase mockGetCartUseCase;
  late MockAddToCartUseCase mockAddToCartUseCase;
  late MockUpdateCartQuantityUseCase mockUpdateCartQuantityUseCase;
  late MockRemoveCartItemUseCase mockRemoveCartItemUseCase;
  late CartCubit cartCubit;

  const tItem1 = CartItemEntity(
    itemId: 'item_1',
    productId: 'prod_1',
    productName: 'Red Roses',
    productImage: 'roses.png',
    unitPrice: 50,
    priceAtAdd: 50,
    quantity: 1,
    lineSubtotal: 50,
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
    quantity: 2,
    lineSubtotal: 60,
    availableStock: 5,
    isAvailable: true,
    priceChanged: false,
    stockChanged: false,
  );

  const tInitialCart = CartEntity(
    cartId: 'cart_123',
    items: [tItem1],
    totalQuantity: 1,
    lineCount: 1,
    subtotal: 50,
    deliveryFee: 20,
    total: 70,
    hasChanges: false,
  );

  const tUpdatedCart = CartEntity(
    cartId: 'cart_123',
    items: [tItem1, tItem2],
    totalQuantity: 3,
    lineCount: 2,
    subtotal: 110,
    deliveryFee: 20,
    total: 130,
    hasChanges: false,
  );

  const tEmptyCart = CartEntity(
    cartId: 'cart_123',
    items: [],
    totalQuantity: 0,
    lineCount: 0,
    subtotal: 0,
    deliveryFee: 20,
    total: 20,
    hasChanges: false,
  );

  setUpAll(() {
    provideDummy<BaseResponse<CartEntity>>(
      SuccessResponse<CartEntity>(tEmptyCart),
    );

    provideDummy<BaseResponse<void>>(SuccessResponse<void>(null));
  });

  setUp(() {
    mockGetCartUseCase = MockGetCartUseCase();
    mockAddToCartUseCase = MockAddToCartUseCase();
    mockUpdateCartQuantityUseCase = MockUpdateCartQuantityUseCase();
    mockRemoveCartItemUseCase = MockRemoveCartItemUseCase();

    cartCubit = CartCubit(
      mockGetCartUseCase,
      mockAddToCartUseCase,
      mockUpdateCartQuantityUseCase,
      mockRemoveCartItemUseCase,
    );
  });

  tearDown(() async {
    await cartCubit.close();
  });

  group('CartCubit - GetCartEvent Tests', () {
    test('initial state should be CartState.initial()', () {
      expect(cartCubit.state, equals(CartState.initial()));
    });

    blocTest<CartCubit, CartState>(
      'emits loading then success when getCartUseCase succeeds',
      build: () {
        when(
          mockGetCartUseCase(),
        ).thenAnswer((_) async => SuccessResponse<CartEntity>(tInitialCart));

        return cartCubit;
      },
      act: (cubit) => cubit.doEvent(GetCartEvent()),
      expect: () => [
        CartState(
          cart: BaseState<CartEntity>(
            isLoading: true,
            errorMessage: null,
            data: null,
          ),
        ),
        CartState(
          cart: BaseState<CartEntity>(
            isLoading: false,
            errorMessage: null,
            data: tInitialCart,
          ),
        ),
      ],
      verify: (_) {
        verify(mockGetCartUseCase()).called(1);
      },
    );

    blocTest<CartCubit, CartState>(
      'emits loading then error when getCartUseCase fails',
      build: () {
        when(
          mockGetCartUseCase(),
        ).thenAnswer((_) async => ErrorResponse<CartEntity>('Network Error'));

        return cartCubit;
      },
      act: (cubit) => cubit.doEvent(GetCartEvent()),
      expect: () => [
        CartState(
          cart: BaseState<CartEntity>(
            isLoading: true,
            errorMessage: null,
            data: null,
          ),
        ),
        CartState(
          cart: BaseState<CartEntity>(
            isLoading: false,
            errorMessage: 'Network Error',
            data: null,
          ),
        ),
      ],
      verify: (_) {
        verify(mockGetCartUseCase()).called(1);
      },
    );
  });

  group('CartCubit - AddToCartEvent Tests', () {
    blocTest<CartCubit, CartState>(
      'emits adding state then updated cart when addToCart succeeds',
      build: () {
        when(
          mockAddToCartUseCase(any),
        ).thenAnswer((_) async => SuccessResponse<void>(null));

        when(
          mockGetCartUseCase(),
        ).thenAnswer((_) async => SuccessResponse<CartEntity>(tUpdatedCart));

        return cartCubit;
      },
      seed: () => CartState(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tInitialCart,
        ),
      ),
      act: (cubit) => cubit.doEvent(AddToCartEvent(productId: 'prod_2')),
      expect: () => [
        CartState(
          cart: BaseState<CartEntity>(
            isLoading: false,
            errorMessage: null,
            data: tInitialCart,
          ),
          addingProductId: 'prod_2',
        ),
        CartState(
          cart: BaseState<CartEntity>(
            isLoading: false,
            errorMessage: null,
            data: tUpdatedCart,
          ),
          addingProductId: null,
        ),
      ],
      verify: (_) {
        verify(mockAddToCartUseCase(any)).called(1);
        verify(mockGetCartUseCase()).called(1);
      },
    );

    blocTest<CartCubit, CartState>(
      'emits error when addToCart API fails',
      build: () {
        when(
          mockAddToCartUseCase(any),
        ).thenAnswer((_) async => ErrorResponse<void>('Failed to add item'));

        return cartCubit;
      },
      seed: () => CartState(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tInitialCart,
        ),
      ),
      act: (cubit) => cubit.doEvent(AddToCartEvent(productId: 'prod_2')),
      expect: () => [
        CartState(
          cart: BaseState<CartEntity>(
            isLoading: false,
            errorMessage: null,
            data: tInitialCart,
          ),
          addingProductId: 'prod_2',
        ),
        CartState(
          cart: BaseState<CartEntity>(
            isLoading: false,
            errorMessage: 'Failed to add item',
            data: tInitialCart,
          ),
          addingProductId: null,
        ),
      ],
      verify: (_) {
        verify(mockAddToCartUseCase(any)).called(1);
        verifyNever(mockGetCartUseCase());
      },
    );

    blocTest<CartCubit, CartState>(
      'emits error when addToCart succeeds but getCart fails',
      build: () {
        when(
          mockAddToCartUseCase(any),
        ).thenAnswer((_) async => SuccessResponse<void>(null));

        when(
          mockGetCartUseCase(),
        ).thenAnswer((_) async => ErrorResponse<CartEntity>('Sync failed'));

        return cartCubit;
      },
      seed: () => CartState(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tInitialCart,
        ),
      ),
      act: (cubit) => cubit.doEvent(AddToCartEvent(productId: 'prod_2')),
      expect: () => [
        CartState(
          cart: BaseState<CartEntity>(
            isLoading: false,
            errorMessage: null,
            data: tInitialCart,
          ),
          addingProductId: 'prod_2',
        ),
        CartState(
          cart: BaseState<CartEntity>(
            isLoading: false,
            errorMessage: 'Sync failed',
            data: tInitialCart,
          ),
          addingProductId: null,
        ),
      ],
      verify: (_) {
        verify(mockAddToCartUseCase(any)).called(1);
        verify(mockGetCartUseCase()).called(1);
      },
    );
  });

  group('CartCubit - ChangeCartQuantityEvent Tests', () {
    blocTest<CartCubit, CartState>(
      'updates quantity locally then updates server after debounce',
      build: () {
        const serverUpdatedItem = CartItemEntity(
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

        const serverUpdatedCart = CartEntity(
          cartId: 'cart_123',
          items: [serverUpdatedItem],
          totalQuantity: 2,
          lineCount: 1,
          subtotal: 100,
          deliveryFee: 20,
          total: 120,
          hasChanges: false,
        );

        when(
          mockUpdateCartQuantityUseCase(
            itemId: anyNamed('itemId'),
            request: anyNamed('request'),
          ),
        ).thenAnswer(
          (_) async => SuccessResponse<CartEntity>(serverUpdatedCart),
        );

        return cartCubit;
      },
      seed: () => CartState(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tInitialCart,
        ),
      ),
      act: (cubit) =>
          cubit.doEvent(ChangeCartQuantityEvent(itemId: 'item_1', quantity: 2)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        // Local optimistic update.
        // Quantity changes, but lineSubtotal is still the old value.
        CartState(
          cart: BaseState<CartEntity>(
            isLoading: false,
            errorMessage: null,
            data: const CartEntity(
              cartId: 'cart_123',
              items: [
                CartItemEntity(
                  itemId: 'item_1',
                  productId: 'prod_1',
                  productName: 'Red Roses',
                  productImage: 'roses.png',
                  unitPrice: 50,
                  priceAtAdd: 50,
                  quantity: 2,
                  lineSubtotal: 50,
                  availableStock: 10,
                  isAvailable: true,
                  priceChanged: false,
                  stockChanged: false,
                ),
              ],
              totalQuantity: 2,
              lineCount: 1,
              subtotal: 100,
              deliveryFee: 20,
              total: 120,
              hasChanges: false,
            ),
          ),
          loadingItemId: 'item_1',
        ),

        // Server response.
        CartState(
          cart: BaseState<CartEntity>(
            isLoading: false,
            errorMessage: null,
            data: const CartEntity(
              cartId: 'cart_123',
              items: [
                CartItemEntity(
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
                ),
              ],
              totalQuantity: 2,
              lineCount: 1,
              subtotal: 100,
              deliveryFee: 20,
              total: 120,
              hasChanges: false,
            ),
          ),
          loadingItemId: null,
        ),
      ],
      verify: (_) {
        verify(
          mockUpdateCartQuantityUseCase(
            itemId: 'item_1',
            request: anyNamed('request'),
          ),
        ).called(1);
      },
    );
    blocTest<CartCubit, CartState>(
      'removes item when quantity becomes zero',
      build: () {
        when(
          mockRemoveCartItemUseCase('item_1'),
        ).thenAnswer((_) async => SuccessResponse<CartEntity>(tEmptyCart));

        return cartCubit;
      },
      seed: () => CartState(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tInitialCart,
        ),
      ),
      act: (cubit) =>
          cubit.doEvent(ChangeCartQuantityEvent(itemId: 'item_1', quantity: 0)),
      expect: () => [
        CartState(
          cart: BaseState<CartEntity>(
            isLoading: false,
            errorMessage: null,
            data: tInitialCart,
          ),
          loadingItemId: 'item_1',
        ),
        CartState(
          cart: BaseState<CartEntity>(
            isLoading: false,
            errorMessage: null,
            data: tEmptyCart,
          ),
          loadingItemId: null,
        ),
      ],
      verify: (_) {
        verify(mockRemoveCartItemUseCase('item_1')).called(1);
      },
    );
  });

  group('CartCubit - RemoveCartItemEvent Tests', () {
    blocTest<CartCubit, CartState>(
      'emits loading then updated cart when remove succeeds',
      build: () {
        when(
          mockRemoveCartItemUseCase('item_1'),
        ).thenAnswer((_) async => SuccessResponse<CartEntity>(tEmptyCart));

        return cartCubit;
      },
      seed: () => CartState(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tInitialCart,
        ),
      ),
      act: (cubit) => cubit.doEvent(RemoveCartItemEvent(itemId: 'item_1')),
      expect: () => [
        CartState(
          cart: BaseState<CartEntity>(
            isLoading: false,
            errorMessage: null,
            data: tInitialCart,
          ),
          loadingItemId: 'item_1',
        ),
        CartState(
          cart: BaseState<CartEntity>(
            isLoading: false,
            errorMessage: null,
            data: tEmptyCart,
          ),
          loadingItemId: null,
        ),
      ],
      verify: (_) {
        verify(mockRemoveCartItemUseCase('item_1')).called(1);
      },
    );

    blocTest<CartCubit, CartState>(
      'emits error when removeCartItemUseCase fails',
      build: () {
        when(mockRemoveCartItemUseCase('item_1')).thenAnswer(
          (_) async => ErrorResponse<CartEntity>('Failed to remove item'),
        );

        return cartCubit;
      },
      seed: () => CartState(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tInitialCart,
        ),
      ),
      act: (cubit) => cubit.doEvent(RemoveCartItemEvent(itemId: 'item_1')),
      expect: () => [
        CartState(
          cart: BaseState<CartEntity>(
            isLoading: false,
            errorMessage: null,
            data: tInitialCart,
          ),
          loadingItemId: 'item_1',
        ),
        CartState(
          cart: BaseState<CartEntity>(
            isLoading: false,
            errorMessage: 'Failed to remove item',
            data: tInitialCart,
          ),
          loadingItemId: null,
        ),
      ],
      verify: (_) {
        verify(mockRemoveCartItemUseCase('item_1')).called(1);
      },
    );
  });
}
