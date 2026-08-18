import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/categories/domain/entities/category_product_entity.dart';
import 'package:flowrist/features/home/categories/domain/repositories/categories_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProductsByCategoryUseCase {
  final CategoriesRepository _repository;

  GetProductsByCategoryUseCase(this._repository);

  Future<BaseResponse<List<CategoryProductEntity>>> call(
    String categoryId,
  ) async {
    return await _repository.getProductsByCategory(categoryId);
  }
}
