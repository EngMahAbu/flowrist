import 'package:flowrist/config/base_response/base_response.dart';

import '../entities/home_layout_entity.dart';

abstract class HomeRepository {
   Future<BaseResponse<List<HomeLayoutEntity>>> getHomeLayout();
}