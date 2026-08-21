import 'package:flowrist/features/home/home/data/data_sources/impl/remote/home_remote_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/data/client/home_api_client.dart';
import 'package:flowrist/features/home/home/data/models/home_model/home_response_model.dart';

import 'home_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([HomeApiClient])
void main() {
  late MockHomeApiClient mockApiClient;
  late HomeRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiClient = MockHomeApiClient();
    dataSource = HomeRemoteDataSourceImpl(mockApiClient);
  });

  group('HomeRemoteDataSourceImpl', () {
    test(
      'should return SuccessResponse when getHomeLayout succeeds',
      () async {
        // Arrange
        final response = <HomeResponseModel>[];

        when(mockApiClient.getHomeLayout())
            .thenAnswer((_) async => response);

        // Act
        final result = await dataSource.getHomeLayout();

        // Assert
        expect(result, isA<SuccessResponse<List<HomeResponseModel>>>());

        final successResponse =
            result as SuccessResponse<List<HomeResponseModel>>;

        expect(successResponse.data, response);

        verify(mockApiClient.getHomeLayout()).called(1);
      },
    );

    test(
      'should call getHomeLayout only once',
      () async {
        // Arrange
        final response = <HomeResponseModel>[];

        when(mockApiClient.getHomeLayout())
            .thenAnswer((_) async => response);

        // Act
        await dataSource.getHomeLayout();

        // Assert
        verify(mockApiClient.getHomeLayout()).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test(
      'should return error response when getHomeLayout throws exception',
      () async {
        // Arrange
        final exception = Exception('Something went wrong');

        when(mockApiClient.getHomeLayout())
            .thenThrow(exception);

        // Act
        final result = await dataSource.getHomeLayout();

        // Assert
        expect(result, isA<ErrorResponse>());

        verify(mockApiClient.getHomeLayout()).called(1);
      },
    );
  });
}