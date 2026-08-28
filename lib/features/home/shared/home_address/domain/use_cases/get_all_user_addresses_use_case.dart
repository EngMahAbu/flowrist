import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/shared/home_address/domain/entities/address_entities/address_entity.dart';
import 'package:flowrist/features/home/shared/home_address/domain/repositories/home_address_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class GetAllUserAddressesUseCase {
  final HomeAddressRepository _repository;

  GetAllUserAddressesUseCase(this._repository);

  Future<BaseResponse<List<AddressEntity>>> call() {
    return _repository.getAllUserAddresses();
  }
}
