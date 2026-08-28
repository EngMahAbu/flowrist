sealed class HomeAddressEvent {}

class InitializeAddress extends HomeAddressEvent {}

class SetDefaultAddress extends HomeAddressEvent {
  final String addressId;

  SetDefaultAddress(this.addressId);
}
