import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/addresses/domain/entities/permission_status_entity.dart';
import 'package:flowrist/features/addresses/domain/entities/service_status_entity.dart';
import 'package:flowrist/features/addresses/domain/use_cases/check_location_permission_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/check_location_service_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/fetch_user_current_location_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/get_address_from_location_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/open_app_settings_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/request_location_permission_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/request_location_service_use_case.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_event.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

@injectable
class AddAddressViewModel extends Cubit<AddAddressState> {
  final CheckLocationPermissionUseCase _checkLocationPermissionUseCase;
  final RequestLocationPermissionUseCase _requestLocationPermissionUseCase;
  final CheckLocationServiceUseCase _checkLocationServiceUseCase;
  final RequestLocationServiceUseCase _requestLocationServiceUseCase;
  final OpenAppSettingsUseCase _openAppSettingsUseCase;
  final FetchUserCurrentLocationUseCase _fetchUserCurrentLocationUseCase;
  final GetAddressFromLocationUseCase _getAddressFromLocationUseCase;

  AddAddressViewModel(this._checkLocationPermissionUseCase,
      this._requestLocationPermissionUseCase,
      this._checkLocationServiceUseCase,
      this._requestLocationServiceUseCase,
      this._openAppSettingsUseCase,
      this._fetchUserCurrentLocationUseCase,
      this._getAddressFromLocationUseCase,) : super(AddAddressState.initial());

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
      case SelectMapLocation():
        _selectMapLocation(event.location);
    }
  }

  void _checkLocationPermission() async {
    emit(state.copyWith(locationPermission: BaseState.loading()));

    final status = await _checkLocationPermissionUseCase();

    emit(state.copyWith(locationPermission: BaseState.success(status)));

    if (status == PermissionStatusEntity.granted) {
      final serviceStatus = await _checkLocationServiceUseCase();
      if (serviceStatus == ServiceStatusEntity.enabled) {
        _fetchUserLocation();
      }
    }
  }

  void _requestLocationPermission() async {
    emit(state.copyWith(locationPermission: BaseState.loading()));

    final status = await _requestLocationPermissionUseCase();

    emit(state.copyWith(locationPermission: BaseState.success(status)));

    if (status == PermissionStatusEntity.granted) {
      _fetchUserLocation();
    }
  }

  void _checkLocationService() async {
    final status = await _checkLocationServiceUseCase();

    emit(
        state.copyWith(locationEnabled: status == ServiceStatusEntity.enabled));
  }

  void _requestLocationService() async {
    final status = await _requestLocationServiceUseCase();

    emit(state.copyWith(locationEnabled: status));

    if (status &&
        state.locationPermission.data == PermissionStatusEntity.granted) {
      _fetchUserLocation();
    }
  }

  void _openAppSettings() async {
    final bool couldOpenAppSettings = await _openAppSettingsUseCase();
    emit(state.copyWith(couldOpenAppSettings: couldOpenAppSettings));
  }

  void _selectMapLocation(LatLng location) async {
    emit(
      state.copyWith(
        selectedLocation: location,
        userLocation: BaseState.loading(),
      ),
    );

    try {
      final address = await _getAddressFromLocationUseCase(location);

      if (address == null) {
        emit(state.copyWith(userLocation: BaseState.error('')));
      } else {
        emit(state.copyWith(userLocation: BaseState.success(address)));
      }
    } catch (e) {
      emit(state.copyWith(userLocation: BaseState.error(e.toString())));
    }
  }

  void _fetchUserLocation() async {
    emit(state.copyWith(userLocation: BaseState.loading()));

    try {
      final (latLng, address) = await _fetchUserCurrentLocationUseCase();

      if (address == null) {
        emit(
          state.copyWith(
            userLocation: BaseState.error(''),
            selectedLocation: latLng,
          ),
        );
      } else {
        emit(
          state.copyWith(
            userLocation: BaseState.success(address),
            selectedLocation: latLng,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(userLocation: BaseState.error(e.toString())));
    }
  }
}
