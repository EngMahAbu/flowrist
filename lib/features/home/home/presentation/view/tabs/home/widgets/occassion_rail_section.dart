import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion_rail_payload_entity.dart';
import 'package:flowrist/features/home/home/presentation/view/tabs/home/widgets/section_title.dart';
 
import 'package:flutter/material.dart';

class OccasionRailSection extends StatelessWidget {
  final OccasionRailPayloadEntity payload;

  const OccasionRailSection({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Shop By Occasion', onViewAll: () {}),

        SizedBox(
          height: 210,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            scrollDirection: Axis.horizontal,
            itemCount: payload.items.length,
            separatorBuilder: (_, __) {
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
                      child: Image.network(
                        item.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
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
