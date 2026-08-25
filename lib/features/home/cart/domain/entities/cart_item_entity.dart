import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String itemId;
  final String productId;
  final String productName;
  final String productImage;
  final num unitPrice;
  final num priceAtAdd;
  final int quantity;
  final int availableStock;

  const CartItemEntity({
    required this.itemId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.unitPrice,
    required this.priceAtAdd,
    required this.quantity,
    required this.availableStock,
  });

  CartItemEntity copyWith({int? quantity}) {
    return CartItemEntity(
      itemId: itemId,
      productId: productId,
      productName: productName,
      productImage: productImage,
      unitPrice: unitPrice,
      priceAtAdd: priceAtAdd,
      quantity: quantity ?? this.quantity,
      availableStock: availableStock,
    );
  }

  @override
  List<Object?> get props => [itemId, productId, quantity];
}
