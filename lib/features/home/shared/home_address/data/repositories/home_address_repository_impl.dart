import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/shared/home_address/data/data_sources/contract/remote/home_address_data_source.dart';
import 'package:flowrist/features/home/shared/home_address/data/model/address_model/address_model.dart';
import 'package:flowrist/features/home/shared/home_address/domain/entities/address_entities/address_entity.dart';

import 'package:flowrist/features/home/shared/home_address/domain/repositories/home_address_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as:AllAddressRepository)
class AddressRepositoryImpl implements AllAddressRepository {
  final AddressRemoteDataSource _remoteDataSource;

  AddressRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<List<AddressEntity>>> getAllUserAddresses() async {
    final response = await _remoteDataSource.getAllUserAddresses();

    switch (response) {
      case SuccessResponse<List<AddressModel>>():
        return SuccessResponse(
          response.data?.map((e) => e.toEntity()).toList() ?? [],
        );
      case ErrorResponse<List<AddressModel>>():
        return ErrorResponse(response.errorMessage);
    }
  }
}
