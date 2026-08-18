import 'package:flowrist/features/home/shared/pagination_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_products_response_dto.g.dart';

@JsonSerializable()
class CategoryProductsResponseDto {
  final bool? status;
  final int? code;
  final String? message;
  final List<CategoryProductDto>? data;
  final PaginationDto? pagination;
  final dynamic errors;

  const CategoryProductsResponseDto({
    this.status,
    this.code,
    this.message,
    this.data,
    this.pagination,
    this.errors,
  });

  factory CategoryProductsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryProductsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryProductsResponseDtoToJson(this);
}

@JsonSerializable()
class CategoryProductDto {
  final String? id;
  final String? name;
  final double? price;
  final bool? inStock;
  final String? categoryId;
  final String? categoryName;
  final String? imageUrl;
  final String? createdAt;

  const CategoryProductDto({
    this.id,
    this.name,
    this.price,
    this.inStock,
    this.categoryId,
    this.categoryName,
    this.imageUrl,
    this.createdAt,
  });

  factory CategoryProductDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryProductDtoToJson(this);
}
