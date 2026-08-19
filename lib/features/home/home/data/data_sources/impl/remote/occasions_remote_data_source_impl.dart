import 'package:flowrist/features/home/home/data/client/occasions_api_client.dart';
import 'package:flowrist/features/home/home/data/data_sources/contract/remote/occasions_remote_data_source.dart';
import 'package:flowrist/features/home/home/data/models/response/occasions_response_dto.dart';
import 'package:flowrist/features/home/home/data/models/response/products_response_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OccasionsRemoteDataSource)
class OccasionsRemoteDataSourceImpl implements OccasionsRemoteDataSource {
  final OccasionsApiClient _apiClient;

  OccasionsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<OccasionsResponseDto> getOccasions() async {
    return await _apiClient.getOccasions();
  }

  @override
  Future<ProductsResponseDto> getProducts({
    String? occasionId,
    String? categoryId,
  }) async {
    return await _apiClient.getProducts(
      occasionId: occasionId,
      categoryId: categoryId,
    );
  }
}
