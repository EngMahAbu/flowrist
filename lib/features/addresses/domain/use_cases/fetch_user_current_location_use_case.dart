import 'package:flowrist/features/addresses/domain/repositories/location_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

@injectable
class FetchUserCurrentLocationUseCase {
  final LocationRepository _locationRepository;

  FetchUserCurrentLocationUseCase(this._locationRepository);

  Future<(LatLng, String?)> call() async {
    return await _locationRepository.fetchUserCurrentLocation();
  }
}
