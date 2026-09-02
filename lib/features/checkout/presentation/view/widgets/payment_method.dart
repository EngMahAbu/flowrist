import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/features/checkout/presentation/view/widgets/payment_method_item.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_cubit.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    const paymentMethods = [
      'cash',
      'creditCard',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.paymentMethod,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 16),

          BlocBuilder<CheckoutCubit, CheckoutState>(
            buildWhen: (previous, current) =>
                previous.selectedPaymentMethod !=
                current.selectedPaymentMethod,
            builder: (context, state) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: paymentMethods.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final paymentMethod = paymentMethods[index];

                  final title = paymentMethod == 'cash'
                      ? localizations.cashOnDelivery
                      : localizations.creditCard;

                  return PaymentMethodItem(
                    title: title,
                    isSelected:
                        state.selectedPaymentMethod == paymentMethod,
                    onTap: () {
                      context
                          .read<CheckoutCubit>()
                          .selectPaymentMethod(paymentMethod);
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}