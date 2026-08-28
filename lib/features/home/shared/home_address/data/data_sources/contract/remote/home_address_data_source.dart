import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/shared/home_address/data/model/address_model/address_model.dart';

abstract interface class AddressRemoteDataSource {
  Future<BaseResponse<List<AddressModel>>> getAllUserAddresses();
}
