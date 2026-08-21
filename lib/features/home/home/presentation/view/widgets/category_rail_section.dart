 
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/features/home/home/domain/entities/home_entities/category_rail_payload_entity.dart';
import 'package:flowrist/features/home/home/presentation/view/widgets/section_title.dart';
import 'package:flutter/material.dart';
 
class CategoryRailSection extends StatelessWidget {
  final CategoryRailPayloadEntity payload;

  const CategoryRailSection({
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
          title: localizations.categories,
          onViewAll: () {},
        ),

        const SizedBox(height: 8),

        SizedBox(
          height: 110,
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
                width: 80,
                child: Column(
                  children: [
                    ClipRRect(
                       borderRadius: BorderRadiusGeometry.circular(20),
                      child: Image.network(item.iconUrl),
                    ),
                    // CircleAvatar(
                    //   radius: 32,
                    //   backgroundImage: NetworkImage(
                    //     item.iconUrl,
                    //   ),
                    // ),
                    const SizedBox(height: 8),
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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