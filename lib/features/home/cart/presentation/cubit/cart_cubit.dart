import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/features/home/cart/data/models/request/add_to_cart_request_dto.dart';
import 'package:flowrist/features/home/cart/data/models/request/update_cart_item_request_dto.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/add_to_cart_use_case.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/get_cart_use_case.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/remove_cart_item_use_case.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/update_cart_quantity_use_case.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_event.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CartCubit extends Cubit<CartState> {
  final GetCartUseCase _getCartUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final UpdateCartQuantityUseCase _updateCartQuantityUseCase;
  final RemoveCartItemUseCase _removeCartItemUseCase;
  final SessionService _sessionService;

  CartCubit(
    this._getCartUseCase,
    this._addToCartUseCase,
    this._updateCartQuantityUseCase,
    this._removeCartItemUseCase,
    this._sessionService,
  ) : super(const CartState());

  void doIntent(CartEvent event) {
    switch (event) {
      case GetCartEvent():
        _handleGetCart();
      case AddToCartEvent():
        _handleAddToCart(event);
      case ChangeCartQuantityEvent():
        _handleChangeQuantity(event);
    }
  }

  Future<void> _handleGetCart() async {
    final token = await _sessionService.getToken();

    if (token.isEmpty) {
      emit(const CartState(isLoading: false, cart: null, errorMessage: null));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _getCartUseCase();

    switch (result) {
      case SuccessResponse(:final data):
        emit(CartState(isLoading: false, cart: data, errorMessage: null));
      case ErrorResponse(:final errorMessage):
        emit(CartState(
          isLoading: false,
          cart: state.cart,
          errorMessage: errorMessage,
        ));
    }
  }

  Future<void> _handleAddToCart(AddToCartEvent event) async {
    final previousCart = state.cart;
    final currentItems = List<CartItemEntity>.from(state.items);

    final existingIndex = currentItems.indexWhere(
      (item) => item.productId == event.productId,
    );

    List<CartItemEntity> updatedItems;
    if (existingIndex != -1) {
      final existingItem = currentItems[existingIndex];
      currentItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
      updatedItems = currentItems;
    } else {
      updatedItems = [...currentItems, event.optimisticItem];
    }

    final optimisticTotal = updatedItems.fold<num>(
      0,
      (sum, item) => sum + (item.unitPrice * item.quantity),
    );

    final optimisticCart = CartEntity(
      cartId: previousCart?.cartId ?? '',
      items: updatedItems,
      total: optimisticTotal,
    );

    emit(CartState(
      isLoading: false,
      cart: optimisticCart,
      errorMessage: null,
    ));

    final result = await _addToCartUseCase(
      AddToCartRequestDto(productId: event.productId, quantity: 1),
    );

    switch (result) {
      case SuccessResponse():
        final syncResult = await _getCartUseCase();
        if (syncResult is SuccessResponse<CartEntity>) {
          emit(CartState(
            isLoading: false,
            cart: syncResult.data,
            errorMessage: null,
          ));
        }
      case ErrorResponse(:final errorMessage):
        emit(CartState(
          isLoading: false,
          cart: previousCart,
          errorMessage: errorMessage,
        ));
    }
  }

  Future<void> _handleChangeQuantity(ChangeCartQuantityEvent event) async {
    final currentItem = state.getItemByProductId(event.productId);
    if (currentItem == null) return;

    final previousCart = state.cart;
    final newQuantity = currentItem.quantity + event.delta;
    final currentItems = List<CartItemEntity>.from(state.items);

    List<CartItemEntity> updatedItems;
    if (newQuantity <= 0) {
      updatedItems = currentItems
          .where((item) => item.productId != event.productId)
          .toList();
    } else {
      updatedItems = currentItems.map((item) {
        return item.productId == event.productId
            ? item.copyWith(quantity: newQuantity)
            : item;
      }).toList();
    }

    final optimisticTotal = updatedItems.fold<num>(
      0,
      (sum, item) => sum + (item.unitPrice * item.quantity),
    );

    final optimisticCart = CartEntity(
      cartId: previousCart?.cartId ?? '',
      items: updatedItems,
      total: optimisticTotal,
    );

    emit(CartState(
      isLoading: false,
      cart: optimisticCart,
      errorMessage: null,
    ));

    if (newQuantity <= 0) {
      final result = await _removeCartItemUseCase(currentItem.itemId);
      switch (result) {
        case SuccessResponse(:final data):
          emit(CartState(isLoading: false, cart: data, errorMessage: null));
        case ErrorResponse(:final errorMessage):
          emit(CartState(
            isLoading: false,
            cart: previousCart,
            errorMessage: errorMessage,
          ));
      }
    } else {
      final result = await _updateCartQuantityUseCase(
        itemId: currentItem.itemId,
        request: UpdateCartItemRequestDto(quantity: newQuantity),
      );
      switch (result) {
        case SuccessResponse(:final data):
          emit(CartState(isLoading: false, cart: data, errorMessage: null));
        case ErrorResponse(:final errorMessage):
          emit(CartState(
            isLoading: false,
            cart: previousCart,
            errorMessage: errorMessage,
          ));
      }
    }
  }
}