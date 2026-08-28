import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/shared/home_address/domain/entities/address_entities/address_entity.dart';

abstract interface class AllAddressRepository {
  Future<BaseResponse<List<AddressEntity>>> getAllUserAddresses();
}
