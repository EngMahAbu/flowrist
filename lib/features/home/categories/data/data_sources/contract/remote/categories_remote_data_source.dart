import 'package:flowrist/features/home/categories/data/models/response/categories_response_dto.dart';
import 'package:flowrist/features/home/categories/data/models/response/category_products_response_dto.dart';

abstract interface class CategoriesRemoteDataSource {
  Future<CategoriesResponseDto> getCategories();
  Future<CategoryProductsResponseDto> getProductsByCategory(String categoryId);
}
