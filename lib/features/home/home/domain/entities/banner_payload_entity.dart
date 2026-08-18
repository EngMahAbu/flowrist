import 'home_payload_entity.dart';

class BannerPayloadEntity extends HomePayloadEntity {
  final String type;
  final String imageUrl;
  final String clickAction;

  const BannerPayloadEntity({
    required this.type,
    required this.imageUrl,
    required this.clickAction,
  });
}