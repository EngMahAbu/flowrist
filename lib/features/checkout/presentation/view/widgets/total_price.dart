import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_request_entity.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/gift_recipient_entity.dart';
import 'package:flowrist/features/checkout/presentation/view/success_order.dart';
import 'package:flowrist/features/checkout/presentation/view/widgets/sub_total.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_cubit.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_event.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_state.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_cubit.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class TotalPrice extends StatelessWidget {
  const TotalPrice({
    super.key,
    required this.cartId,
    required this.addressId,
    required this.subTotal,
  });

  final String cartId;
  final String addressId;
  final double subTotal;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocConsumer<CheckoutCubit, CheckoutState>(
      listenWhen: (previous, current) {
        return previous.placeOrderState.isLoading !=
                current.placeOrderState.isLoading ||
            previous.placeOrderState.data != current.placeOrderState.data ||
            previous.placeOrderState.errorMessage !=
                current.placeOrderState.errorMessage;
      },
      listener: (context, state) async {
        final placeOrderState = state.placeOrderState;

        if (placeOrderState.errorMessage != null) {
          if (!context.mounted) return;

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(placeOrderState.errorMessage!)),
            );

          return;
        }

        if (placeOrderState.isLoading) {
          return;
        }

        final order = placeOrderState.data;

        if (order == null) {
          // Clear cart locally
          // context.read<CartCubit>().clearCartLocally();

          if (!context.mounted) return;

          // Go directly to second screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SuccessOrder()),
          );

          return;
        }

        final sessionUrl = order.sessionUrl;

        if (sessionUrl.isEmpty) {
          if (!context.mounted) return;

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Payment session URL is missing')),
            );

          return;
        }

        final uri = Uri.tryParse(sessionUrl);

        if (uri == null) {
          if (!context.mounted) return;

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(localizations.invalidpaymentURL)),
            );

          return;
        }

        // Clear cart locally
        context.read<CartCubit>().doEvent(GetCartEvent());

        // Open Stripe
        final success = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        if (!success) {
          if (!context.mounted) return;

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(localizations.couldnotopenpaymentpage)),
            );

          return;
        }
      },
      builder: (context, state) {
        final deliveryFee = state.deliveryFeeState.data?.deliveryFee ?? 0.0;

        final total = subTotal + deliveryFee;

        final isLoading = state.placeOrderState.isLoading;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SubTotal(
                title: localizations.subTotal,
                price: '${localizations.egp}${subTotal.toStringAsFixed(2)}',
              ),

              const SizedBox(height: 8),

              SubTotal(
                title: localizations.deliveryFee,
                price: '${localizations.egp}${deliveryFee.toStringAsFixed(2)}',
              ),

              const Divider(height: 30, thickness: 1),

              SubTotal(
                title: localizations.total,
                price: '${localizations.egp}${total.toStringAsFixed(2)}',
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : () => _placeOrder(context),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(localizations.placeOrder),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _placeOrder(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final cubit = context.read<CheckoutCubit>();
    final state = cubit.state;

    final selectedPaymentMethod = state.selectedPaymentMethod;

    if (selectedPaymentMethod == null) {
      _showMessage(context, localizations.pleaseselectapaymentmethod);
      return;
    }

    if (state.isGift) {
      if (state.giftName.trim().isEmpty) {
        _showMessage(context, localizations.pleaseenterrecipientname);
        return;
      }

      if (state.giftPhone.trim().isEmpty) {
        _showMessage(context, localizations.pleaseenterrecipientphone);
        return;
      }
    }

    final isCard = selectedPaymentMethod == Endpoints.creditCard;

    final request = CardOrderRequestEntity(
      cartId: cartId,
      addressId: addressId,
      isGift: state.isGift,
      giftRecipient: state.isGift
          ? GiftRecipientEntity(
              recipientName: state.giftName.trim(),
              recipientPhone: state.giftPhone.trim(),
            )
          : null,
      paymentMethod: isCard ? Endpoints.card : Endpoints.cod,
      paymentGateway: isCard ? Endpoints.stripe : null,
    );

    cubit.doEvent(PlaceOrder(order: request));
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
