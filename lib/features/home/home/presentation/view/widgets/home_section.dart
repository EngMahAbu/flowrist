 
import 'package:flowrist/features/home/home/domain/entities/home_entities/banner_payload_entity.dart';
import 'package:flowrist/features/home/home/domain/entities/home_entities/category_rail_payload_entity.dart';
import 'package:flowrist/features/home/home/domain/entities/home_entities/home_layout_entity.dart';
import 'package:flowrist/features/home/home/domain/entities/home_entities/occasion_rail_payload_entity.dart';
import 'package:flowrist/features/home/home/domain/entities/home_entities/product_rail_payload_entity.dart';
import 'package:flowrist/features/home/home/presentation/view/widgets/banner_section.dart';
import 'package:flowrist/features/home/home/presentation/view/widgets/category_rail_section.dart';
import 'package:flowrist/features/home/home/presentation/view/widgets/occassion_rail_section.dart';
import 'package:flowrist/features/home/home/presentation/view/widgets/product_rail_section.dart';
import 'package:flutter/material.dart';

class HomeSection extends StatelessWidget {
  final HomeLayoutEntity section;

  const HomeSection({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    switch (section.type) {
      case 'banner':
        return GestureDetector(
          onTap: () {},
          child: BannerSection(payload: section.payload as BannerPayloadEntity),
        );

      case 'category_rail':
        return GestureDetector(
          onTap: () {},
          child: CategoryRailSection(
            payload: section.payload as CategoryRailPayloadEntity,
          ),
        );

      case 'product_rail':
        return GestureDetector(
          onTap: () {},
          child: ProductRailSection(
            payload: section.payload as ProductRailPayloadEntity,
          ),
        );

      case 'occasion_rail':
        return GestureDetector(
          onTap: () {},
          child: OccasionRailSection(
            payload: section.payload as OccasionRailPayloadEntity,
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
