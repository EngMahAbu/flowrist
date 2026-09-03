sealed class CheckoutEvent {}

class GetAddressesEvent extends CheckoutEvent {}

class SelectDeliveryAddressEvent extends CheckoutEvent {
  final String addressId;

  SelectDeliveryAddressEvent(this.addressId);
}
