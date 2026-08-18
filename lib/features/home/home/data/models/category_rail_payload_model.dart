 
import 'package:flowrist/features/home/home/data/models/category_item_model.dart';
import 'package:flowrist/features/home/home/data/models/home_payload_model.dart';
import 'package:flowrist/features/home/home/domain/entities/category_item_entity.dart';
import 'package:flowrist/features/home/home/domain/entities/category_rail_payload_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'category_rail_payload_model.g.dart';    
@JsonSerializable()
class CategoryRailPayloadModel extends HomePayloadModel {
  final List<CategoryItemModel> items;
  final String viewAllAction;

  const CategoryRailPayloadModel({
    required super.type,
    required this.items,
    required this.viewAllAction,
  });

  factory CategoryRailPayloadModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CategoryRailPayloadModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CategoryRailPayloadModelToJson(this);

  @override
  CategoryRailPayloadEntity toEntity() {
    return CategoryRailPayloadEntity(
      type: type,
      items: items
          .map(
            (item) => CategoryItemEntity(
              id: item.id,
              name: item.name,
              iconUrl: item.iconUrl,
            ),
          )
          .toList(),
      viewAllAction: viewAllAction,
    );
  }
}