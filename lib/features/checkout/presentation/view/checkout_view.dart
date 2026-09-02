import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/features/checkout/presentation/view/widgets/delivery_address.dart';
import 'package:flowrist/features/checkout/presentation/view/widgets/delivery_time.dart';
import 'package:flowrist/features/checkout/presentation/view/widgets/gift_methods.dart';
import 'package:flowrist/features/checkout/presentation/view/widgets/payment_method.dart';
import 'package:flowrist/features/checkout/presentation/view/widgets/total_price.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: false,
              pinned: false,
              titleSpacing: 0,
              title: Text(localizations.checkout),
              leading: IconButton(
                onPressed: context.pop,
                icon: const Icon(Icons.arrow_back_ios),
              ),
            ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  DeliveryTime(),
                  const SizedBox(height: 25),

                  const _SectionDivider(),
                  const SizedBox(height: 25),

                  DeliveryAddress(),
                  const SizedBox(height: 25),

                  const _SectionDivider(),
                  const SizedBox(height: 25),

                  PaymentMethod(),
                  const SizedBox(height: 25),

                  const _SectionDivider(),
                  const SizedBox(height: 25),

                  GiftMethods(),
                  const SizedBox(height: 25),

                  const _SectionDivider(),
                  const SizedBox(height: 25),

                  TotalPrice(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: double.infinity,
      color: const Color(0xffEAEAEA),
    );
  }
}
