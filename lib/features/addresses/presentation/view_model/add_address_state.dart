import 'package:equatable/equatable.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class AddAddressState extends Equatable {
  final BaseState<PermissionStatus> locationPermission;
  final bool locationEnabled;
  final bool? couldOpenAppSettings;
  final BaseState<String>? userLocation;
  final LatLng? selectedLocation;
  final bool manualEntry;

  const AddAddressState({
    required this.locationPermission,
    required this.locationEnabled,
    this.couldOpenAppSettings,
    required this.userLocation,
    this.selectedLocation,
    this.manualEntry = false,
  });

  AddAddressState.initial()
    : locationPermission = BaseState.initial(),
      locationEnabled = false,
      couldOpenAppSettings = null,
      userLocation = BaseState.initial(),
      selectedLocation = null,
      manualEntry = false;

  AddAddressState copyWith({
    BaseState<PermissionStatus>? locationPermission,
    bool? locationEnabled,
    bool? couldOpenAppSettings,
    BaseState<String>? userLocation,
    LatLng? selectedLocation,
    bool? manualEntry,
  }) {
    return AddAddressState(
      locationPermission: locationPermission ?? this.locationPermission,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      couldOpenAppSettings: couldOpenAppSettings ?? this.couldOpenAppSettings,
      userLocation: userLocation ?? this.userLocation,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      manualEntry: manualEntry ?? this.manualEntry,
    );
  }

  @override
  List<Object?> get props => [
    locationPermission,
    locationEnabled,
    couldOpenAppSettings,
    userLocation,
    selectedLocation,
    manualEntry,
  ];
}
