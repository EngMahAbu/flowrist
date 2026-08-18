import 'home_payload_entity.dart';
import 'category_item_entity.dart';

class CategoryRailPayloadEntity extends HomePayloadEntity {
  final String type;
  final List<CategoryItemEntity> items;
  final String viewAllAction;

  const CategoryRailPayloadEntity({
    required this.type,
    required this.items,
    required this.viewAllAction,
  });
}