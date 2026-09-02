class CheckoutSessionEntity {
  final String checkoutUrl;
  final String stripeSessionId;
  final String paymentAttemptId;

  const CheckoutSessionEntity({
    required this.checkoutUrl,
    required this.stripeSessionId,
    required this.paymentAttemptId,
  });
}