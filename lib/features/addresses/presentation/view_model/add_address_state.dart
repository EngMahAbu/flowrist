import 'package:equatable/equatable.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/addresses/domain/entities/coordinates_entity.dart';
import 'package:flowrist/features/addresses/domain/entities/permission_status_entity.dart';

class AddAddressState extends Equatable {
  final BaseState<PermissionStatusEntity> locationPermission;
  final bool locationEnabled;
  final bool? couldOpenAppSettings;
  final BaseState<String>? userLocation;
  final CoordinatesEntity? selectedLocation;
  final bool manualEntry;
  final bool isMapConfigured;

  const AddAddressState({
    required this.locationPermission,
    required this.locationEnabled,
    this.couldOpenAppSettings,
    required this.userLocation,
    this.selectedLocation,
    this.manualEntry = false,
    this.isMapConfigured = true,
  });

  AddAddressState.initial()
    : locationPermission = BaseState.initial(),
      locationEnabled = false,
      couldOpenAppSettings = null,
      userLocation = BaseState.initial(),
      selectedLocation = null,
      manualEntry = false,
      isMapConfigured = true;

  AddAddressState copyWith({
    BaseState<PermissionStatusEntity>? locationPermission,
    bool? locationEnabled,
    bool? couldOpenAppSettings,
    BaseState<String>? userLocation,
    CoordinatesEntity? selectedLocation,
    bool? manualEntry,
    bool? isMapConfigured,
  }) {
    return AddAddressState(
      locationPermission: locationPermission ?? this.locationPermission,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      couldOpenAppSettings: couldOpenAppSettings ?? this.couldOpenAppSettings,
      userLocation: userLocation ?? this.userLocation,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      manualEntry: manualEntry ?? this.manualEntry,
      isMapConfigured: isMapConfigured ?? this.isMapConfigured,
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
    isMapConfigured,
  ];
}
