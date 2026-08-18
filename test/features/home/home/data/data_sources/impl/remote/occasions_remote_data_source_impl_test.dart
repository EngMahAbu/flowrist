import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flowrist/features/home/home/data/client/occasions_api_client.dart';
import 'package:flowrist/features/home/home/data/data_sources/impl/remote/occasions_remote_data_source_impl.dart';
import 'package:flowrist/features/home/home/data/models/response/occasions_response_dto.dart';
import 'package:flowrist/features/home/home/data/models/response/products_response_dto.dart';

import 'occasions_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([OccasionsApiClient])
void main() {
  late OccasionsRemoteDataSourceImpl dataSource;
  late MockOccasionsApiClient mockApiClient;

  setUpAll(() {
    provideDummy<OccasionsResponseDto>(const OccasionsResponseDto());
    provideDummy<ProductsResponseDto>(const ProductsResponseDto());
  });

  setUp(() {
    mockApiClient = MockOccasionsApiClient();
    dataSource = OccasionsRemoteDataSourceImpl(mockApiClient);
  });

  group('getOccasions', () {
    const tResponseDto = OccasionsResponseDto(
      message: 'Success',
      data: [OccasionDto(id: '1', name: 'Birthday')],
    );

    test(
      'should call apiClient.getOccasions and return OccasionsResponseDto',
      () async {
        // Arrange
        when(
          mockApiClient.getOccasions(),
        ).thenAnswer((_) async => tResponseDto);

        // Act
        final result = await dataSource.getOccasions();

        // Assert
        expect(result, tResponseDto);
        verify(mockApiClient.getOccasions()).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test('should throw an exception when apiClient fails', () async {
      // Arrange
      when(mockApiClient.getOccasions()).thenThrow(Exception('API error'));

      // Act & Assert
      expect(() => dataSource.getOccasions(), throwsA(isA<Exception>()));
      verify(mockApiClient.getOccasions()).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });
  });

  group('getProductsByOccasion', () {
    const tOccasionId = 'occ-123';
    const tProductsDto = ProductsResponseDto(
      message: 'Success',
      data: [ProductDto(id: 'p1', name: 'Bouquet')],
    );

    test(
      'should call apiClient.getProductsByOccasion with correct parameter',
      () async {
        // Arrange
        when(
          mockApiClient.getProductsByOccasion(tOccasionId),
        ).thenAnswer((_) async => tProductsDto);

        // Act
        final result = await dataSource.getProductsByOccasion(tOccasionId);

        // Assert
        expect(result, tProductsDto);
        verify(mockApiClient.getProductsByOccasion(tOccasionId)).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test('should throw an exception when apiClient fails', () async {
      // Arrange
      when(
        mockApiClient.getProductsByOccasion(tOccasionId),
      ).thenThrow(Exception('API error'));

      // Act & Assert
      expect(
        () => dataSource.getProductsByOccasion(tOccasionId),
        throwsA(isA<Exception>()),
      );
      verify(mockApiClient.getProductsByOccasion(tOccasionId)).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });
  });
}
