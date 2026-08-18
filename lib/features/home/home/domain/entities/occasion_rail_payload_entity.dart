import 'home_payload_entity.dart';
import 'occasion_item_entity.dart';

class OccasionRailPayloadEntity extends HomePayloadEntity {
  final String type;
  final List<OccasionItemEntity> items;
  final String viewAllAction;

  const OccasionRailPayloadEntity({
    required this.type,
    required this.items,
    required this.viewAllAction,
  });
}