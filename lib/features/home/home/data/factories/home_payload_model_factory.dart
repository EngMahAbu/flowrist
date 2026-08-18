import '../models/banner_payload_model.dart';
import '../models/category_rail_payload_model.dart';
import '../models/home_payload_model.dart';
import '../models/occasion_rail_payload_model.dart';
import '../models/product_rail_payload_model.dart';

class HomePayloadModelFactory {
  const HomePayloadModelFactory();

  HomePayloadModel fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'banner':
        return BannerPayloadModel.fromJson(json);

      case 'category_rail':
        return CategoryRailPayloadModel.fromJson(json);

      case 'product_rail':
        return ProductRailPayloadModel.fromJson(json);

      case 'occasion_rail':
        return OccasionRailPayloadModel.fromJson(json);

      default:
        throw UnsupportedError(
          'Unknown home payload type: ${json['type']}',
        );
    }
  }
}