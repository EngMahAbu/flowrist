import 'package:flowrist/features/addresses/data/mappers/permission_status_mapper.dart';
import 'package:flowrist/features/addresses/data/mappers/service_status_mapper.dart';
import 'package:flowrist/features/addresses/domain/entities/permission_status_entity.dart';
import 'package:flowrist/features/addresses/domain/entities/service_status_entity.dart';
import 'package:flowrist/features/addresses/domain/repositories/location_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data_sources/location_service.dart';
import '../data_sources/permission_handler.dart';

@LazySingleton(as: LocationRepository)
class LocationRepositoryImpl implements LocationRepository {
  final PermissionsHandler _permissionsHandler;
  final LocationService _locationService;

  LocationRepositoryImpl(this._permissionsHandler, this._locationService);

  @override
  Future<PermissionStatusEntity> checkLocationPermission() async {
    final status = await _permissionsHandler.checkForegroundLocation();
    return status.toEntity();
  }

  @override
  Future<PermissionStatusEntity> requestLocationPermission() async {
    final status = await _permissionsHandler.requestPermission(
      Permission.locationWhenInUse,
    );
    return status.toEntity();
  }

  @override
  Future<ServiceStatusEntity> checkLocationService() async {
    final status = await _permissionsHandler.checkLocationServiceStatus();
    return status.toEntity();
  }

  @override
  Future<bool> requestLocationService() async {
    return await _locationService.requestLocationService();
  }

  @override
  Future<bool> openAppSettings() async {
    return await _permissionsHandler.openSettings();
  }

  @override
  Future<String?> getAddressFromLocation(LatLng location) async {
    final locations = await _locationService.getCurrentAddresses(
      lat: location.latitude,
      long: location.longitude,
    );

    if (locations.isEmpty) return null;

    final street = _locationService.formatAddress(locations[0]);
    return street.isEmpty ? null : street;
  }

  @override
  Future<(LatLng, String?)> fetchUserCurrentLocation() async {
    final locationData = await _locationService.fetchUserCurrentLocation();
    final latLng = LatLng(locationData.latitude, locationData.longitude);
    final address = await getAddressFromLocation(latLng);
    return (latLng, address);
  }
}
