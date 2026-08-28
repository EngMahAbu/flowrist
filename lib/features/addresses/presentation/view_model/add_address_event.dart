import 'package:latlong2/latlong.dart';

sealed class AddAddressEvent {}

class CheckLocationPermission extends AddAddressEvent {}

class RequestLocationPermission extends AddAddressEvent {}

class CheckLocationService extends AddAddressEvent {}

class RequestLocationService extends AddAddressEvent {}

class OpenAppSettings extends AddAddressEvent {}

class FetchUserLocation extends AddAddressEvent {}

class SelectMapLocation extends AddAddressEvent {
  final LatLng location;

  SelectMapLocation(this.location);
}
