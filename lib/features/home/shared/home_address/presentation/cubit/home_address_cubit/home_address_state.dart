import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/shared/home_address/domain/entities/address_entities/address_entity.dart';
import 'package:flowrist/features/home/shared/home_address/domain/entities/address_entities/default_address_entity.dart';

class HomeAddressState {
  final BaseState<List<AddressEntity>> addressesState;
  final BaseState<DefaultAddressEntity> setDefaultAddressState;
  final AddressEntity? selectedAddress;

  HomeAddressState({
    required this.addressesState,
    required this.setDefaultAddressState,
    this.selectedAddress,
  });

  HomeAddressState copyWith({
    BaseState<List<AddressEntity>>? addressesState,
    BaseState<DefaultAddressEntity>? setDefaultAddressState,
    AddressEntity? selectedAddress,
    bool clearSelectedAddress = false,
  }) {
    return HomeAddressState(
      addressesState:
          addressesState ?? this.addressesState,
      setDefaultAddressState:
          setDefaultAddressState ??
              this.setDefaultAddressState,
      selectedAddress: clearSelectedAddress
          ? null
          : selectedAddress ?? this.selectedAddress,
    );
  }
}