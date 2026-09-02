class CreateCheckoutEntity {
  final String orderId;
  final int amountTotal;
  final String currency;
  const CreateCheckoutEntity({
    required this.orderId,
    required this.amountTotal,
    required this.currency,
  });
}
