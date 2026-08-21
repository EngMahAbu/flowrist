import '../../../domain/entities/home_entities/home_layout_entity.dart';
import '../../factories/home_payload_model_factory.dart';
import 'home_payload_model.dart';

class HomeLayoutModel {
  final String id;
  final String type;
  final String title;
  final int order;
  final bool isEnabled;
  final HomePayloadModel payload;

  const HomeLayoutModel({
    required this.id,
    required this.type,
    required this.title,
    required this.order,
    required this.isEnabled,
    required this.payload,
  });

  factory HomeLayoutModel.fromJson(Map<String, dynamic> json) {
    return HomeLayoutModel(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      order: json['order'] as int,
      isEnabled: json['isEnabled'] as bool,
      payload: const HomePayloadModelFactory().fromJson(
        json['payload'] as Map<String, dynamic>,
      ),
    );
  }

  HomeLayoutEntity toEntity() {
    return HomeLayoutEntity(
      id: id,
      type: type,
      title: title,
      order: order,
      isEnabled: isEnabled,
      payload: payload.toEntity(),
    );
  }
}
