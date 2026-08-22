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

  const HomeSection({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    switch (section) {
      case HomeLayoutEntity(
          type: 'banner',
          payload: BannerPayloadEntity payload,
        ):
        return GestureDetector(
          onTap: () {},
          child: BannerSection(payload: payload),
        );

      case HomeLayoutEntity(
          type: 'category_rail',
          payload: CategoryRailPayloadEntity payload,
        ):
        return GestureDetector(
          onTap: () {},
          child: CategoryRailSection(payload: payload),
        );

      case HomeLayoutEntity(
          type: 'product_rail',
          payload: ProductRailPayloadEntity payload,
        ):
        return GestureDetector(
          onTap: () {},
          child: ProductRailSection(payload: payload),
        );

      case HomeLayoutEntity(
          type: 'occasion_rail',
          payload: OccasionRailPayloadEntity payload,
        ):
        return GestureDetector(
          onTap: () {},
          child: OccasionRailSection(payload: payload),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}