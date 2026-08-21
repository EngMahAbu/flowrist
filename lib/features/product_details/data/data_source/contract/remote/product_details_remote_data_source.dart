import 'package:flowrist/config/base_response/base_response.dart';

import '../../../models/product_details_dto.dart';

abstract interface class ProductDetailsRemoteDataSource {
  Future<BaseResponse<ProductDetailsDto>> getProductDetails(
      String productId,
      );
}