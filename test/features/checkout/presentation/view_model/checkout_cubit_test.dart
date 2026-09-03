import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_entity.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_request_entity.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/delivery_fee_entity.dart';
import 'package:flowrist/features/checkout/domain/use_cases/get_delivery_fee_use_case.dart';
import 'package:flowrist/features/checkout/domain/use_cases/place_order_use_case.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_cubit.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_event.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'checkout_cubit_test.mocks.dart';

@GenerateMocks([
  PlaceOrderUseCase,
  GetDeliveryFeeUseCase,
])
void main() {
  late MockPlaceOrderUseCase mockPlaceOrderUseCase;
  late MockGetDeliveryFeeUseCase mockGetDeliveryFeeUseCase;
  late CheckoutCubit cubit;

  const addressId = 'address-123';
  const cartId = 'cart-123';

  final cardOrder = CardOrderEntity(
    orderId: 'order-123',
    status: 'Placed',
    gateway: 'Stripe',
    sessionId: 'cs_test_123',
    sessionUrl: 'https://checkout.stripe.com/test',
    successUrl: 'https://example.com/success',
    cancelUrl: 'https://example.com/cancel',
    expiresAt: DateTime(2026, 9, 5, 12),
    amount: 150.0,
    currency: 'EGP',
    estimatedDeliveryAt: DateTime(2026, 9, 7),
  );

  final deliveryFee = DeliveryFeeEntity(
    addressId: addressId,
    deliveryFee: 25.0,
    estimatedDeliveryAt: DateTime(2026, 9, 5),
    isServiceable: true,
  );

  final orderRequest = CardOrderRequestEntity(
    cartId: cartId,
    addressId: addressId,
    isGift: false,
    giftRecipient: null,
    paymentMethod: 'Card',
    paymentGateway: 'Stripe',
  );

  setUpAll(() {
    provideDummy<BaseResponse<CardOrderEntity?>>(
      SuccessResponse<CardOrderEntity?>(
        null,
      ),
    );

    provideDummy<BaseResponse<DeliveryFeeEntity>>(
      SuccessResponse<DeliveryFeeEntity>(
        deliveryFee,
      ),
    );
  });

  setUp(() {
    mockPlaceOrderUseCase = MockPlaceOrderUseCase();
    mockGetDeliveryFeeUseCase = MockGetDeliveryFeeUseCase();

    cubit = CheckoutCubit(
      mockPlaceOrderUseCase,
      mockGetDeliveryFeeUseCase,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group('CheckoutCubit', () {
    // -----------------------------------------------------------------------
    // Initial State
    // -----------------------------------------------------------------------

    test('initial state should be CheckoutState.initial()', () {
      expect(
        cubit.state,
        CheckoutState.initial(),
      );
    });

    // -----------------------------------------------------------------------
    // Select Payment Method
    // -----------------------------------------------------------------------

    blocTest<CheckoutCubit, CheckoutState>(
      'should select payment method',
      build: () => cubit,
      act: (cubit) {
        cubit.doEvent(
          SelectPaymentMethod(
            paymentMethod: 'Card',
          ),
        );
      },
      expect: () => [
        isA<CheckoutState>()
            .having(
              (state) => state.selectedPaymentMethod,
              'selectedPaymentMethod',
              'Card',
            )
            .having(
              (state) => state.placeOrderState,
              'placeOrderState',
              BaseState<CardOrderEntity?>.initial(),
            ),
      ],
    );

    // -----------------------------------------------------------------------
    // Update Gift Info
    // -----------------------------------------------------------------------

    blocTest<CheckoutCubit, CheckoutState>(
      'should update gift information',
      build: () => cubit,
      act: (cubit) {
        cubit.doEvent(
          UpdateGiftInfo(
            isGift: true,
            name: 'Ahmed Mohamed',
            phone: '01012345678',
          ),
        );
      },
      expect: () => [
        isA<CheckoutState>()
            .having(
              (state) => state.isGift,
              'isGift',
              true,
            )
            .having(
              (state) => state.giftName,
              'giftName',
              'Ahmed Mohamed',
            )
            .having(
              (state) => state.giftPhone,
              'giftPhone',
              '01012345678',
            ),
      ],
    );

    // -----------------------------------------------------------------------
    // Place Order - Success with Card
    // -----------------------------------------------------------------------

    blocTest<CheckoutCubit, CheckoutState>(
      'should emit loading then success when place order succeeds with card',
      build: () {
        when(
          mockPlaceOrderUseCase(orderRequest),
        ).thenAnswer(
          (_) async => SuccessResponse<CardOrderEntity?>(
            cardOrder,
          ),
        );

        return cubit;
      },
      act: (cubit) {
        cubit.doEvent(
          PlaceOrder(
            order: orderRequest,
          ),
        );
      },
      expect: () => [
        isA<CheckoutState>().having(
          (state) => state.placeOrderState.isLoading,
          'placeOrderState.isLoading',
          true,
        ),
        isA<CheckoutState>()
            .having(
              (state) => state.placeOrderState.data,
              'placeOrderState.data',
              cardOrder,
            )
            .having(
              (state) => state.placeOrderState.isLoading,
              'placeOrderState.isLoading',
              false,
            )
            .having(
              (state) => state.placeOrderState.errorMessage,
              'placeOrderState.errorMessage',
              null,
            ),
      ],
      verify: (_) {
        verify(
          mockPlaceOrderUseCase(orderRequest),
        ).called(1);

        verifyNoMoreInteractions(mockPlaceOrderUseCase);
      },
    );

    // -----------------------------------------------------------------------
    // Place Order - COD Success
    // -----------------------------------------------------------------------

    blocTest<CheckoutCubit, CheckoutState>(
      'should emit loading then success with null data when COD place order succeeds',
      build: () {
        when(
          mockPlaceOrderUseCase(orderRequest),
        ).thenAnswer(
          (_) async => SuccessResponse<CardOrderEntity?>(
            null,
          ),
        );

        return cubit;
      },
      act: (cubit) {
        cubit.doEvent(
          PlaceOrder(
            order: orderRequest,
          ),
        );
      },
      expect: () => [
        isA<CheckoutState>().having(
          (state) => state.placeOrderState.isLoading,
          'placeOrderState.isLoading',
          true,
        ),
        isA<CheckoutState>()
            .having(
              (state) => state.placeOrderState.data,
              'placeOrderState.data',
              null,
            )
            .having(
              (state) => state.placeOrderState.isLoading,
              'placeOrderState.isLoading',
              false,
            )
            .having(
              (state) => state.placeOrderState.errorMessage,
              'placeOrderState.errorMessage',
              null,
            ),
      ],
      verify: (_) {
        verify(
          mockPlaceOrderUseCase(orderRequest),
        ).called(1);

        verifyNoMoreInteractions(mockPlaceOrderUseCase);
      },
    );

    // -----------------------------------------------------------------------
    // Place Order - Error
    // -----------------------------------------------------------------------

    blocTest<CheckoutCubit, CheckoutState>(
      'should emit loading then error when place order fails',
      build: () {
        when(
          mockPlaceOrderUseCase(orderRequest),
        ).thenAnswer(
          (_) async => ErrorResponse<CardOrderEntity?>(
            'Failed to place order',
          ),
        );

        return cubit;
      },
      act: (cubit) {
        cubit.doEvent(
          PlaceOrder(
            order: orderRequest,
          ),
        );
      },
      expect: () => [
        isA<CheckoutState>().having(
          (state) => state.placeOrderState.isLoading,
          'placeOrderState.isLoading',
          true,
        ),
        isA<CheckoutState>()
            .having(
              (state) => state.placeOrderState.errorMessage,
              'placeOrderState.errorMessage',
              'Failed to place order',
            )
            .having(
              (state) => state.placeOrderState.isLoading,
              'placeOrderState.isLoading',
              false,
            )
            .having(
              (state) => state.placeOrderState.data,
              'placeOrderState.data',
              null,
            ),
      ],
      verify: (_) {
        verify(
          mockPlaceOrderUseCase(orderRequest),
        ).called(1);

        verifyNoMoreInteractions(mockPlaceOrderUseCase);
      },
    );

    // -----------------------------------------------------------------------
    // Place Order - Exception
    // -----------------------------------------------------------------------

    blocTest<CheckoutCubit, CheckoutState>(
      'should emit loading then error when place order throws exception',
      build: () {
        when(
          mockPlaceOrderUseCase(orderRequest),
        ).thenThrow(
          Exception('Something went wrong'),
        );

        return cubit;
      },
      act: (cubit) {
        cubit.doEvent(
          PlaceOrder(
            order: orderRequest,
          ),
        );
      },
      expect: () => [
        isA<CheckoutState>().having(
          (state) => state.placeOrderState.isLoading,
          'placeOrderState.isLoading',
          true,
        ),
        isA<CheckoutState>().having(
          (state) => state.placeOrderState.errorMessage,
          'placeOrderState.errorMessage',
          'Exception: Something went wrong',
        ),
      ],
      verify: (_) {
        verify(
          mockPlaceOrderUseCase(orderRequest),
        ).called(1);

        verifyNoMoreInteractions(mockPlaceOrderUseCase);
      },
    );

    // -----------------------------------------------------------------------
    // Get Delivery Fee - Success
    // -----------------------------------------------------------------------

    blocTest<CheckoutCubit, CheckoutState>(
      'should emit loading then success when get delivery fee succeeds',
      build: () {
        when(
          mockGetDeliveryFeeUseCase(
            addressId: addressId,
            cartId: cartId,
          ),
        ).thenAnswer(
          (_) async => SuccessResponse<DeliveryFeeEntity>(
            deliveryFee,
          ),
        );

        return cubit;
      },
      act: (cubit) {
        cubit.doEvent(
          GetDeliveryFee(
            addressId: addressId,
            cartId: cartId,
          ),
        );
      },
      expect: () => [
        isA<CheckoutState>().having(
          (state) => state.deliveryFeeState.isLoading,
          'deliveryFeeState.isLoading',
          true,
        ),
        isA<CheckoutState>()
            .having(
              (state) => state.deliveryFeeState.data,
              'deliveryFeeState.data',
              deliveryFee,
            )
            .having(
              (state) => state.deliveryFeeState.isLoading,
              'deliveryFeeState.isLoading',
              false,
            )
            .having(
              (state) => state.deliveryFeeState.errorMessage,
              'deliveryFeeState.errorMessage',
              null,
            ),
      ],
      verify: (_) {
        verify(
          mockGetDeliveryFeeUseCase(
            addressId: addressId,
            cartId: cartId,
          ),
        ).called(1);

        verifyNoMoreInteractions(mockGetDeliveryFeeUseCase);
      },
    );

    // -----------------------------------------------------------------------
    // Get Delivery Fee - Error
    // -----------------------------------------------------------------------

    blocTest<CheckoutCubit, CheckoutState>(
      'should emit loading then error when get delivery fee fails',
      build: () {
        when(
          mockGetDeliveryFeeUseCase(
            addressId: addressId,
            cartId: cartId,
          ),
        ).thenAnswer(
          (_) async => ErrorResponse<DeliveryFeeEntity>(
            'Failed to get delivery fee',
          ),
        );

        return cubit;
      },
      act: (cubit) {
        cubit.doEvent(
          GetDeliveryFee(
            addressId: addressId,
            cartId: cartId,
          ),
        );
      },
      expect: () => [
        isA<CheckoutState>().having(
          (state) => state.deliveryFeeState.isLoading,
          'deliveryFeeState.isLoading',
          true,
        ),
        isA<CheckoutState>()
            .having(
              (state) => state.deliveryFeeState.errorMessage,
              'deliveryFeeState.errorMessage',
              'Failed to get delivery fee',
            )
            .having(
              (state) => state.deliveryFeeState.isLoading,
              'deliveryFeeState.isLoading',
              false,
            )
            .having(
              (state) => state.deliveryFeeState.data,
              'deliveryFeeState.data',
              null,
            ),
      ],
      verify: (_) {
        verify(
          mockGetDeliveryFeeUseCase(
            addressId: addressId,
            cartId: cartId,
          ),
        ).called(1);

        verifyNoMoreInteractions(mockGetDeliveryFeeUseCase);
      },
    );

    // -----------------------------------------------------------------------
    // Get Delivery Fee - Null Data
    // -----------------------------------------------------------------------

    blocTest<CheckoutCubit, CheckoutState>(
      'should emit loading then error when delivery fee response contains null data',
      build: () {
        when(
          mockGetDeliveryFeeUseCase(
            addressId: addressId,
            cartId: cartId,
          ),
        ).thenAnswer(
          (_) async => SuccessResponse<DeliveryFeeEntity>(
            null,
          ),
        );

        return cubit;
      },
      act: (cubit) {
        cubit.doEvent(
          GetDeliveryFee(
            addressId: addressId,
            cartId: cartId,
          ),
        );
      },
      expect: () => [
        isA<CheckoutState>().having(
          (state) => state.deliveryFeeState.isLoading,
          'deliveryFeeState.isLoading',
          true,
        ),
        isA<CheckoutState>()
            .having(
              (state) => state.deliveryFeeState.errorMessage,
              'deliveryFeeState.errorMessage',
              'Invalid delivery fee response',
            )
            .having(
              (state) => state.deliveryFeeState.isLoading,
              'deliveryFeeState.isLoading',
              false,
            ),
      ],
      verify: (_) {
        verify(
          mockGetDeliveryFeeUseCase(
            addressId: addressId,
            cartId: cartId,
          ),
        ).called(1);

        verifyNoMoreInteractions(mockGetDeliveryFeeUseCase);
      },
    );

    // -----------------------------------------------------------------------
    // Get Delivery Fee - Exception
    // -----------------------------------------------------------------------

    blocTest<CheckoutCubit, CheckoutState>(
      'should emit loading then error when get delivery fee throws exception',
      build: () {
        when(
          mockGetDeliveryFeeUseCase(
            addressId: addressId,
            cartId: cartId,
          ),
        ).thenThrow(
          Exception('Delivery service unavailable'),
        );

        return cubit;
      },
      act: (cubit) {
        cubit.doEvent(
          GetDeliveryFee(
            addressId: addressId,
            cartId: cartId,
          ),
        );
      },
      expect: () => [
        isA<CheckoutState>().having(
          (state) => state.deliveryFeeState.isLoading,
          'deliveryFeeState.isLoading',
          true,
        ),
        isA<CheckoutState>().having(
          (state) => state.deliveryFeeState.errorMessage,
          'deliveryFeeState.errorMessage',
          'Exception: Delivery service unavailable',
        ),
      ],
      verify: (_) {
        verify(
          mockGetDeliveryFeeUseCase(
            addressId: addressId,
            cartId: cartId,
          ),
        ).called(1);

        verifyNoMoreInteractions(mockGetDeliveryFeeUseCase);
      },
    );

    // -----------------------------------------------------------------------
    // Reset
    // -----------------------------------------------------------------------

    blocTest<CheckoutCubit, CheckoutState>(
      'should reset state to initial',
      build: () => cubit,
      seed: () => CheckoutState.initial().copyWith(
        selectedPaymentMethod: 'Card',
        isGift: true,
        giftName: 'Ahmed',
        giftPhone: '01012345678',
      ),
      act: (cubit) {
        cubit.reset();
      },
      expect: () => [
        CheckoutState.initial(),
      ],
    );
  });
}