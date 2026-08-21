import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/models/product_details_request_dto.dart';

class PriceSection extends StatelessWidget {
  final ProductDetailsRequestDto product;

  const PriceSection({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${product.discountedPrice.toStringAsFixed(0)} EGP',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        if (product.discountPercent > 0) ...[
          const SizedBox(width: 12),

          Text(
            '${product.price.toStringAsFixed(0)} EGP',
            style: theme.textTheme.bodyLarge?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
            ),
          ),

          const SizedBox(width: 12),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              '${product.discountPercent.toStringAsFixed(0)}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }
}