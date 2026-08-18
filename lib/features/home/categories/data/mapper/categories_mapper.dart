import 'package:flowrist/features/home/categories/data/models/response/categories_response_dto.dart';
import 'package:flowrist/features/home/categories/data/models/response/category_products_response_dto.dart';
import 'package:flowrist/features/home/categories/domain/entities/category_entity.dart';
import 'package:flowrist/features/home/categories/domain/entities/category_product_entity.dart';

abstract final class CategoriesMapper {
  static List<CategoryEntity> toCategoryEntities(CategoriesResponseDto dto) {
    return dto.data?.map((item) {
          return CategoryEntity(
            id: item.id ?? '',
            name: item.name ?? '',
            iconUrl: item.iconUrl ?? '',
          );
        }).toList() ??
        [];
  }

  static List<CategoryProductEntity> toProductEntities(
    CategoryProductsResponseDto dto,
  ) {
    return dto.data?.map((item) {
          return CategoryProductEntity(
            id: item.id ?? '',
            name: item.name ?? '',
            price: item.price ?? 0.0,
            inStock: item.inStock ?? false,
            categoryId: item.categoryId ?? '',
            categoryName: item.categoryName ?? '',
            imageUrl: item.imageUrl ?? '',
          );
        }).toList() ??
        [];
  }
}
