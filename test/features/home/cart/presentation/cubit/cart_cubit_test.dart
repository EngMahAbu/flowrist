import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/add_to_cart_use_case.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/get_cart_use_case.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/remove_cart_item_use_case.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/update_cart_quantity_use_case.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_cubit.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_event.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_state.dart';

@GenerateMocks([
  GetCartUseCase,
  AddToCartUseCase,
  UpdateCartQuantityUseCase,
  RemoveCartItemUseCase,
  SessionService,
])
import 'cart_cubit_test.mocks.dart';

void main() {
  late MockGetCartUseCase mockGetCartUseCase;
  late MockAddToCartUseCase mockAddToCartUseCase;
  late MockUpdateCartQuantityUseCase mockUpdateCartQuantityUseCase;
  late MockRemoveCartItemUseCase mockRemoveCartItemUseCase;
  late MockSessionService mockSessionService;
  late CartCubit cartCubit;

  const tItem1 = CartItemEntity(
    itemId: 'item_1',
    productId: 'prod_1',
    productName: 'Red Roses',
    productImage: 'roses.png',
    unitPrice: 50,
    priceAtAdd: 50,
    quantity: 1,
    availableStock: 10,
  );

  const tItem2 = CartItemEntity(
    itemId: 'item_2',
    productId: 'prod_2',
    productName: 'Tulips',
    productImage: 'tulips.png',
    unitPrice: 30,
    priceAtAdd: 30,
    quantity: 2,
    availableStock: 5,
  );

  final tInitialCart = CartEntity(
    cartId: 'cart_123',
    items: const [tItem1],
    total: 50,
  );

  final tUpdatedCart = CartEntity(
    cartId: 'cart_123',
    items: const [tItem1, tItem2],
    total: 110,
  );

  setUpAll(() {
    provideDummy<BaseResponse<CartEntity>>(
      SuccessResponse<CartEntity>(CartEntity(cartId: '', items: [], total: 0)),
    );
    provideDummy<BaseResponse<void>>(SuccessResponse<void>(null));
  });

  setUp(() {
    mockGetCartUseCase = MockGetCartUseCase();
    mockAddToCartUseCase = MockAddToCartUseCase();
    mockUpdateCartQuantityUseCase = MockUpdateCartQuantityUseCase();
    mockRemoveCartItemUseCase = MockRemoveCartItemUseCase();
    mockSessionService = MockSessionService();

    cartCubit = CartCubit(
      mockGetCartUseCase,
      mockAddToCartUseCase,
      mockUpdateCartQuantityUseCase,
      mockRemoveCartItemUseCase,
      mockSessionService,
    );
  });

  tearDown(() {
    cartCubit.close();
  });

  group('CartCubit - GetCartEvent Tests', () {
    test('initial state should be CartState with default values', () {
      expect(cartCubit.state, equals(const CartState()));
    });

    blocTest<CartCubit, CartState>(
      'emits [CartState(cart: null)] immediately without API call if token is empty',
      build: () {
        when(mockSessionService.getToken()).thenAnswer((_) async => '');
        return cartCubit;
      },
      act: (cubit) => cubit.doIntent(GetCartEvent()),
      expect: () => [
        const CartState(isLoading: false, cart: null, errorMessage: null),
      ],
      verify: (_) {
        verify(mockSessionService.getToken()).called(1);
        verifyZeroInteractions(mockGetCartUseCase);
      },
    );

    blocTest<CartCubit, CartState>(
      'emits [loading, success] when token exists and getCart succeeds',
      build: () {
        when(
          mockSessionService.getToken(),
        ).thenAnswer((_) async => 'jwt_token');
        when(
          mockGetCartUseCase(),
        ).thenAnswer((_) async => SuccessResponse<CartEntity>(tInitialCart));
        return cartCubit;
      },
      act: (cubit) => cubit.doIntent(GetCartEvent()),
      expect: () => [
        const CartState(isLoading: true, cart: null, errorMessage: null),
        CartState(isLoading: false, cart: tInitialCart, errorMessage: null),
      ],
      verify: (_) {
        verify(mockGetCartUseCase()).called(1);
      },
    );

    blocTest<CartCubit, CartState>(
      'emits [loading, error] when token exists and getCart fails',
      build: () {
        when(
          mockSessionService.getToken(),
        ).thenAnswer((_) async => 'jwt_token');
        when(
          mockGetCartUseCase(),
        ).thenAnswer((_) async => ErrorResponse<CartEntity>('Network Error'));
        return cartCubit;
      },
      act: (cubit) => cubit.doIntent(GetCartEvent()),
      expect: () => [
        const CartState(isLoading: true, cart: null, errorMessage: null),
        const CartState(
          isLoading: false,
          cart: null,
          errorMessage: 'Network Error',
        ),
      ],
    );
  });

  group('CartCubit - AddToCartEvent Tests', () {
    blocTest<CartCubit, CartState>(
      'performs optimistic add and verifies sync with API',
      build: () {
        when(
          mockAddToCartUseCase(any),
        ).thenAnswer((_) async => SuccessResponse<void>(null));
        when(
          mockGetCartUseCase(),
        ).thenAnswer((_) async => SuccessResponse<CartEntity>(tUpdatedCart));
        return cartCubit;
      },
      seed: () => CartState(cart: tInitialCart),
      act: (cubit) => cubit.doIntent(
        AddToCartEvent(productId: 'prod_2', optimisticItem: tItem2),
      ),
      expect: () => [
        CartState(
          isLoading: false,
          cart: CartEntity(
            cartId: 'cart_123',
            items: const [tItem1, tItem2],
            total: 110,
          ),
          errorMessage: null,
        ),
      ],
      verify: (_) {
        verify(mockAddToCartUseCase(any)).called(1);
        verify(mockGetCartUseCase()).called(1);
      },
    );

    blocTest<CartCubit, CartState>(
      'reverts to previousCart and emits error message when addToCart API fails',
      build: () {
        when(
          mockAddToCartUseCase(any),
        ).thenAnswer((_) async => ErrorResponse<void>('Failed to add item'));
        return cartCubit;
      },
      seed: () => CartState(cart: tInitialCart),
      act: (cubit) => cubit.doIntent(
        AddToCartEvent(productId: 'prod_2', optimisticItem: tItem2),
      ),
      expect: () => [
        CartState(
          isLoading: false,
          cart: CartEntity(
            cartId: 'cart_123',
            items: const [tItem1, tItem2],
            total: 110,
          ),
          errorMessage: null,
        ),
        CartState(
          isLoading: false,
          cart: tInitialCart,
          errorMessage: 'Failed to add item',
        ),
      ],
    );
  });

  group('CartCubit - ChangeCartQuantityEvent Tests', () {
    blocTest<CartCubit, CartState>(
      'optimistically increments quantity and updates via API on delta = +1',
      build: () {
        final serverUpdatedCart = CartEntity(
          cartId: 'cart_123',
          items: [tItem1.copyWith(quantity: 2)],
          total: 100,
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
      seed: () => CartState(cart: tInitialCart),
      act: (cubit) => cubit.doIntent(
        ChangeCartQuantityEvent(productId: 'prod_1', delta: 1),
      ),
      expect: () => [
        CartState(
          isLoading: false,
          cart: CartEntity(
            cartId: 'cart_123',
            items: [tItem1.copyWith(quantity: 2)],
            total: 100,
          ),
          errorMessage: null,
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
      'optimistically removes item and calls removeCartItemUseCase when quantity drops to 0',
      build: () {
        const emptyCart = CartEntity(cartId: 'cart_123', items: [], total: 0);
        when(
          mockRemoveCartItemUseCase(any),
        ).thenAnswer((_) async => SuccessResponse<CartEntity>(emptyCart));
        return cartCubit;
      },
      seed: () => CartState(cart: tInitialCart),
      act: (cubit) => cubit.doIntent(
        ChangeCartQuantityEvent(productId: 'prod_1', delta: -1),
      ),
      expect: () => [
        const CartState(
          isLoading: false,
          cart: CartEntity(cartId: 'cart_123', items: [], total: 0),
          errorMessage: null,
        ),
      ],
      verify: (_) {
        verify(mockRemoveCartItemUseCase('item_1')).called(1);
      },
    );
  });
}
