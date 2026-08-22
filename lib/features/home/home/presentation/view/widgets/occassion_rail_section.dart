import 'package:cached_network_image/cached_network_image.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/home/home/domain/entities/home_entities/occasion_rail_payload_entity.dart';
import 'package:flowrist/features/home/home/presentation/view/widgets/section_title.dart';

import 'package:flutter/material.dart';

class OccasionRailSection extends StatelessWidget {
  final OccasionRailPayloadEntity payload;

  const OccasionRailSection({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: localizations.occasion, onViewAll: () {}),

        SizedBox(
          height: 210,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: item.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                          placeholder: (context, url) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                color: AppColors.white50,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },

            // Error state
            errorWidget: (context, url, error) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                color: AppColors.white50,
                child: const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 40,
                  ),
                ),
              );
            },
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.medium18Inter.copyWith(fontSize: 15),
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
