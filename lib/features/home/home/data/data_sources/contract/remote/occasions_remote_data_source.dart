import 'package:flowrist/features/home/home/data/models/response/occasions_response_dto.dart';
import 'package:flowrist/features/home/home/data/models/response/products_response_dto.dart';

abstract interface class OccasionsRemoteDataSource {
  Future<OccasionsResponseDto> getOccasions();
  Future<ProductsResponseDto> getProducts({
    String? occasionId,
    String? categoryId,
  });
}
