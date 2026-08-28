import 'package:flowrist/features/addresses/domain/entities/permission_status_entity.dart';
import 'package:flowrist/features/addresses/domain/entities/service_status_entity.dart';
import 'package:latlong2/latlong.dart';

abstract interface class LocationRepository {
  Future<PermissionStatusEntity> checkLocationPermission();

  Future<PermissionStatusEntity> requestLocationPermission();

  Future<ServiceStatusEntity> checkLocationService();

  Future<bool> requestLocationService();

  Future<bool> openAppSettings();

  Future<String?> getAddressFromLocation(LatLng location);

  Future<(LatLng, String?)> fetchUserCurrentLocation();
}
