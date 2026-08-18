import 'package:equatable/equatable.dart';

class CategoryProductEntity extends Equatable {
  final String id;
  final String name;
  final double price;
  final bool inStock;
  final String categoryId;
  final String categoryName;
  final String imageUrl;

  const CategoryProductEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.inStock,
    required this.categoryId,
    required this.categoryName,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    inStock,
    categoryId,
    categoryName,
    imageUrl,
  ];
}
