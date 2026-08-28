import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/shared/home_address/data/data_sources/contract/remote/set_default_address_data_source.dart';
import 'package:flowrist/features/home/shared/home_address/data/model/address_model/default_address_response_model.dart';
import 'package:flowrist/features/home/shared/home_address/domain/entities/address_entities/default_address_entity.dart';
import 'package:flowrist/features/home/shared/home_address/domain/repositories/set_default_address_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SetDefaultAddressRepository)
class SetDefaultAddressRepositoryImpl implements SetDefaultAddressRepository {
  final SetDefaultAddressDataSource _dataSource;

  SetDefaultAddressRepositoryImpl(this._dataSource);

  @override
  Future<BaseResponse<DefaultAddressEntity>> setDefaultAddress(
    String addressId,
  ) async {
    final response = await _dataSource.setDefaultAddress(addressId);

    switch (response) {
      case SuccessResponse<DefaultAddressResponseModel>():
        return SuccessResponse(response.data?.toEntity());

      case ErrorResponse<DefaultAddressResponseModel>():
        return ErrorResponse(response.errorMessage);
    }
  }
}
