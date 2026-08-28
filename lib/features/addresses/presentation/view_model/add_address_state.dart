import 'package:equatable/equatable.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:permission_handler/permission_handler.dart';

// TODO: check the warning here later
class AddAddressState extends Equatable {
  BaseState<PermissionStatus> locationPermission;
  bool locationEnabled;
  bool? couldOpenAppSettings;
  BaseState<String>? userLocation;
  bool manualEntry = false;

  AddAddressState({
    required this.locationPermission,
    required this.locationEnabled,
    this.couldOpenAppSettings,
    required this.userLocation,
    bool manualEntry = false,
  });

  AddAddressState.initial()
    : locationPermission = BaseState.initial(),
      locationEnabled = false,
      userLocation = BaseState.initial(),
      manualEntry = false;

  AddAddressState copyWith({
    BaseState<PermissionStatus>? locationPermission,
    bool? locationEnabled,
    bool? couldOpenAppSettings,
    BaseState<String>? userLocation,
    bool? manualEntry,
  }) {
    return AddAddressState(
      locationPermission: locationPermission ?? this.locationPermission,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      couldOpenAppSettings: couldOpenAppSettings ?? this.couldOpenAppSettings,
      userLocation: userLocation ?? this.userLocation,
      manualEntry: manualEntry ?? this.manualEntry,
    );
  }

  @override
  List<Object?> get props => [
    locationPermission,
    locationEnabled,
    couldOpenAppSettings,
    userLocation,
    manualEntry,
  ];
}
