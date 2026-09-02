import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/features/checkout/presentation/view/widgets/sub_total.dart';
import 'package:flutter/material.dart';

class TotalPrice extends StatelessWidget {
  const TotalPrice({super.key});

  @override
  Widget build(BuildContext context) {
      final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SubTotal(title: localizations.subTotal, price: "\$100.00"),
          SizedBox(height: 8),
          SubTotal(title: localizations.deliveryFee, price: "\$10.00"),
       
          Divider(
            height: 30,
            thickness: 1,
          ),
          SubTotal(
            title: localizations.total,
            price: "\$110.00",
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: () {}, child: Text(localizations.placeOrder)),
          ),
        ],
      ),
    );
  }
}
