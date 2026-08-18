import 'home_payload_entity.dart';
import 'product_item_entity.dart';

class ProductRailPayloadEntity extends HomePayloadEntity {
  final String type;
  final List<ProductItemEntity> items;
  final String viewAllAction;

  const ProductRailPayloadEntity({
    required this.type,
    required this.items,
    required this.viewAllAction,
  });
}