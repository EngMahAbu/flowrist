import 'package:cached_network_image/cached_network_image.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/config/session/session_guard.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_images.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String oldPrice;
  final String discount;
  final String image;

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.whiteBase,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.white70, width: 0.5),
      ),
      child: Column(
        children: [
          _buildProductImage(),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(title, style: AppStyles.regular13),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${AppLocalizations.of(context)!.egp} $price',
                style: AppStyles.regular14InterW500,
              ),
              const SizedBox(width: 6),
              Text(
                oldPrice,
                style: AppStyles.regular14Inter.copyWith(
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                discount,
                style: AppStyles.regular14Inter.copyWith(
                  color: AppColors.green,
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.shopping_cart_outlined, size: 18),
              style: ElevatedButton.styleFrom(
                textStyle: AppStyles.regular13W500,
              ),
              onPressed: () async {
                final canContinue = await checkGuestMode(context);
                if (!canContinue) {
                  return;
                }
                context.push(AppRoutes.cartTab);
              },
              label: Text(AppLocalizations.of(context)!.addToCart),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    if (image.isEmpty) {
      return Image.asset(
        AppImages.cardDefultImage,
        width: double.infinity,
        height: 150,
        fit: BoxFit.cover,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: image,
        width: double.infinity,
        height: 150,
        fit: BoxFit.cover,
        // placeholder: (context, url) {
        //   return const SizedBox(
        //     width: double.infinity,
        //     height: 150,
        //     child: Center(child: CircularProgressIndicator()),
        //   );
        // },
        errorWidget: (context, url, error) {
          return Image.asset(
            AppImages.cardDefultImage,
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
