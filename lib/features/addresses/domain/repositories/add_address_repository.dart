import '../../../../config/base_response/base_response.dart';
import '../../../../shared/domain/entities/city_entity.dart';
import '../../../../shared/domain/entities/governorate_entity.dart';

abstract interface class AddAddressRepository {
  Future<BaseResponse<List<GovernorateEntity>>> getGovernorates();

  Future<BaseResponse<List<CityEntity>>> getCities(int governorateId);
}
