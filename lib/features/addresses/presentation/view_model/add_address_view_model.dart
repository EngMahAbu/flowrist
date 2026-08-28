import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/config/location_service/location_service.dart';
import 'package:flowrist/config/permission_handler/permission_handler.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_event.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@injectable
class AddAddressViewModel extends Cubit<AddAddressState> {
  final PermissionsHandler _permissionsHandler;
  final LocationService _locationService;

  AddAddressViewModel(this._permissionsHandler, this._locationService)
    : super(AddAddressState.initial());

  void doEvent(AddAddressEvent event) {
    switch (event) {
      case CheckLocationPermission():
        _checkLocationPermission();
      case RequestLocationPermission():
        _requestLocationPermission();
      case CheckLocationService():
        _checkLocationService();
      case RequestLocationService():
        _requestLocationService();
      case OpenAppSettings():
        _openAppSettings();
      case FetchUserLocation():
        _fetchUserLocation();
    }
  }

  void _checkLocationPermission() async {
    emit(state.copyWith(locationPermission: BaseState.loading()));

    final status = await _permissionsHandler.checkForegroundLocation();

    emit(state.copyWith(locationPermission: BaseState.success(status)));
  }

  void _requestLocationPermission() async {
    emit(state.copyWith(locationPermission: BaseState.loading()));

    final status = await _permissionsHandler.requestPermission(
      Permission.locationWhenInUse,
    );

    emit(state.copyWith(locationPermission: BaseState.success(status)));
  }

  void _checkLocationService() async {
    final status = await _permissionsHandler.checkLocationServiceStatus();

    emit(state.copyWith(locationEnabled: status == ServiceStatus.enabled));
  }

  void _requestLocationService() async {
    final status = await _locationService.requestLocationService();

    emit(state.copyWith(locationEnabled: status));
  }

  void _openAppSettings() async {
    final bool couldOpenAppSettings = await _permissionsHandler.openSettings();
    emit(state.copyWith(couldOpenAppSettings: couldOpenAppSettings));
  }

  void _fetchUserLocation() async {
    emit(state.copyWith(userLocation: BaseState.loading()));

    final locationData = await _locationService.fetchUserCurrentLocation();
    final locations = await _locationService.getCurrentAddresses(
      lat: locationData.latitude,
      long: locationData.longitude,
    );

    if (locations.isEmpty) {
      emit(state.copyWith(userLocation: BaseState.error('')));
    }

    final street = _locationService.formatAddress(locations[0]);

    if (street.isEmpty) {
      emit(state.copyWith(userLocation: BaseState.error('')));
    } else {
      emit(state.copyWith(userLocation: BaseState.success(street)));
    }
  }
}
