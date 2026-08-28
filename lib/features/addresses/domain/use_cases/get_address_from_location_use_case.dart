import 'package:flowrist/features/addresses/domain/repositories/location_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

@injectable
class GetAddressFromLocationUseCase {
  final LocationRepository _locationRepository;

  GetAddressFromLocationUseCase(this._locationRepository);

  Future<String?> call(LatLng location) async {
    return await _locationRepository.getAddressFromLocation(location);
  }
}
