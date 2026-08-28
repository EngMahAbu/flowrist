import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/shared/home_address/domain/entities/address_entities/default_address_entity.dart';
import 'package:flowrist/features/home/shared/home_address/domain/repositories/set_default_address_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetDefaultAddressUseCase {
  final SetDefaultAddressRepository _repository;

  SetDefaultAddressUseCase(this._repository);

  Future<BaseResponse<DefaultAddressEntity>> call(String addressId) {
    return _repository.setDefaultAddress(addressId);
  }
}
