import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/shared/home_address/domain/entities/address_entities/default_address_entity.dart';

abstract class SetDefaultAddressRepository {
  Future<BaseResponse<DefaultAddressEntity>> setDefaultAddress(
    String addressId,
  );
}
