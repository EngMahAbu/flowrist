import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';
import 'package:flutter/material.dart';

class CartItemCard extends StatelessWidget {
  final CartItemEntity item;
  final VoidCallback onDelete;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final bool isLoading;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onIncrease,
    required this.onDecrease,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.whiteBase,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey, width: 0.5),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              width: 100,
              height: 120,
              child: Image.network(
                item.productImage,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: AppColors.white70.withValues(alpha: 0.15),
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.purpleBase,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.white70.withValues(alpha: 0.2),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.white70,
                      size: 32,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.productName,
                        style: AppStyles.medium16InterBlack,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    IconButton(
                      onPressed: isLoading ? null : onDelete,
                      icon: Icon(Icons.delete_outline, color: AppColors.red),
                    ),
                  ],
                ),

                Text(
                  'Available stock: ${item.availableStock}',
                  style: AppStyles.regular13Grey,
                ),

                const SizedBox(height: 25),

                Row(
                  children: [
                    Text('EGP ${item.unitPrice}', style: AppStyles.semiBold14),

                    const Spacer(),

                    IconButton(
                      onPressed: isLoading ? null : onDecrease,
                      icon: const Icon(
                        Icons.remove,
                        color: AppColors.blackBase,
                      ),
                    ),

                    Text(
                      item.quantity.toString(),
                      style: AppStyles.regular14Inter,
                    ),

                    IconButton(
                      onPressed: isLoading ? null : onIncrease,
                      icon: const Icon(Icons.add, color: AppColors.blackBase),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
