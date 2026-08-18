import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/domain/entities/product_entity.dart';
import 'package:flowrist/features/home/home/domain/repositories/occasions_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProductsByOccasionUseCase {
  final OccasionsRepository _repository;

  GetProductsByOccasionUseCase(this._repository);

  Future<BaseResponse<List<ProductEntity>>> call(String occasionId) async {
    return await _repository.getProductsByOccasion(occasionId);
  }
}
