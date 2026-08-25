import 'package:dio/dio.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/features/home/cart/data/models/request/add_to_cart_request_dto.dart';
import 'package:flowrist/features/home/cart/data/models/request/update_cart_item_request_dto.dart';
import 'package:flowrist/features/home/cart/data/models/response/cart_response_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'cart_api_client.g.dart';

@singleton
@RestApi()
abstract class CartApiClient {
  @factoryMethod
  factory CartApiClient(Dio dio) = _CartApiClient;

  @GET(Endpoints.cart)
  Future<CartResponseDto> getCart();

  @POST(Endpoints.cartItems)
  Future<dynamic> addToCart(
    @Body() AddToCartRequestDto request,
  );

  @PATCH('${Endpoints.cartItems}/{itemId}')
  Future<CartResponseDto> updateCartItemQuantity(
    @Path('itemId') String itemId,
    @Body() UpdateCartItemRequestDto request,
  );

  @DELETE('${Endpoints.cartItems}/{itemId}')
  Future<CartResponseDto> removeCartItem(
    @Path('itemId') String itemId,
  );
}