import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/home/home/domain/entities/home_entities/product_rail_payload_entity.dart';
import 'package:flowrist/features/home/home/presentation/view/widgets/section_title.dart';
 
import 'package:flutter/material.dart';

class ProductRailSection extends StatelessWidget {
  final ProductRailPayloadEntity payload;

  const ProductRailSection({
    super.key,
    required this.payload,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: localizations.bestSellers,
          onViewAll: () {},
        ),

        const SizedBox(height: 8),

        SizedBox(
          height: 220,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: payload.items.length,
            separatorBuilder: (_, _) {
              return const SizedBox(width: 12);
            },
            itemBuilder: (context, index) {
              final item = payload.items[index];

              return SizedBox(
                width: 160,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.network(
                        item.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                                style: AppStyles.regular12Inter.copyWith(fontWeight: FontWeight.w600),
                          ),
                
                          const SizedBox(height: 4),
                
                          Text(
                            '\$${item.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}