import 'package:dio/dio.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../models/home_response_model.dart';

part 'home_api_client.g.dart';
@lazySingleton
@RestApi()
abstract class HomeApiClient {
    @factoryMethod
  factory HomeApiClient(Dio dio) = _HomeApiClient;

  @GET(Endpoints.home)
  Future<List<HomeResponseModel>> getHomeLayout();
}