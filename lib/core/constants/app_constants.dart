import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class AppConstants {
  static const String storageTokenKey = 'userTokenKey';
  static const String rememberMeKey = 'rememberMeKey';
  static const String guestModeKey = 'guestModeKey';
  static const String categoryId = 'categoryId';
  static const String occasionId = 'OccasionId';
  static const String itemIdKey = 'itemId';

  static String get mapTilerApiKey => dotenv.env['MAPTILER_API_KEY'] ?? '';
}

