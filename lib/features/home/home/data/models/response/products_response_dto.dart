import 'package:json_annotation/json_annotation.dart';

part 'products_response_dto.g.dart';

@JsonSerializable()
class ProductsResponseDto {
  final String? message;
  final List<ProductDto>? data;

  const ProductsResponseDto({this.message, this.data});

  factory ProductsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProductsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsResponseDtoToJson(this);
}

@JsonSerializable()
class ProductDto {
  final String? id;
  final String? name;
  final double? price;
  final bool? inStock;
  final String? categoryId;
  final String? categoryName;
  final String? imageUrl;

  const ProductDto({
    this.id,
    this.name,
    this.price,
    this.inStock,
    this.categoryId,
    this.categoryName,
    this.imageUrl,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);
}
