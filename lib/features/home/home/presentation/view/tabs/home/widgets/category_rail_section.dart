 
import 'package:flowrist/features/home/home/domain/entities/category_rail_payload_entity.dart';
import 'package:flowrist/features/home/home/presentation/view/tabs/home/widgets/section_title.dart';
import 'package:flutter/material.dart';
 
class CategoryRailSection extends StatelessWidget {
  final CategoryRailPayloadEntity payload;

  const CategoryRailSection({
    super.key,
    required this.payload,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: 'Categories',
          onViewAll: () {},
        ),

        const SizedBox(height: 8),

        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: payload.items.length,
            separatorBuilder: (_, __) {
              return const SizedBox(width: 12);
            },
            itemBuilder: (context, index) {
              final item = payload.items[index];

              return SizedBox(
                width: 80,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: NetworkImage(
                        item.iconUrl,
                      ),
                    ),
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