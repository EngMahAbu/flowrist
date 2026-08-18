import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/data/data_sources/contract/remote/occasions_remote_data_source.dart';
import 'package:flowrist/features/home/home/data/models/response/occasions_response_dto.dart';
import 'package:flowrist/features/home/home/data/models/response/products_response_dto.dart';
import 'package:flowrist/features/home/home/data/repositories/occasions_repository_impl.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion_entity.dart';
import 'package:flowrist/features/home/home/domain/entities/product_entity.dart';

import 'occasions_repository_impl_test.mocks.dart';

@GenerateMocks([OccasionsRemoteDataSource])
void main() {
  late OccasionsRepositoryImpl repository;
  late MockOccasionsRemoteDataSource mockRemoteDataSource;

  setUpAll(() {
    provideDummy<OccasionsResponseDto>(const OccasionsResponseDto());
    provideDummy<ProductsResponseDto>(const ProductsResponseDto());
  });

  setUp(() {
    mockRemoteDataSource = MockOccasionsRemoteDataSource();
    repository = OccasionsRepositoryImpl(mockRemoteDataSource);
  });

  group('getOccasions', () {
    const tResponseDto = OccasionsResponseDto(
      data: [OccasionDto(id: '1', name: 'Birthday', imageUrl: 'url1')],
    );

    test(
      'should return SuccessResponse<List<OccasionEntity>> when remote call succeeds',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getOccasions(),
        ).thenAnswer((_) async => tResponseDto);

        // Act
        final result = await repository.getOccasions();

        // Assert
        expect(result, isA<SuccessResponse<List<OccasionEntity>>>());
        final data = (result as SuccessResponse<List<OccasionEntity>>).data;
        expect(data?.first.id, '1');
        expect(data?.first.name, 'Birthday');
        verify(mockRemoteDataSource.getOccasions()).called(1);
      },
    );

    test(
      'should return ErrorResponse when remote data source throws an exception',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getOccasions(),
        ).thenThrow(Exception('Connection error'));

        // Act
        final result = await repository.getOccasions();

        // Assert
        expect(result, isA<ErrorResponse<List<OccasionEntity>>>());
        verify(mockRemoteDataSource.getOccasions()).called(1);
      },
    );
  });

  group('getProductsByOccasion', () {
    const tOccasionId = 'occ-123';
    const tProductsDto = ProductsResponseDto(
      data: [
        ProductDto(
          id: 'p1',
          name: 'Lily Bouquet',
          price: 45.0,
          inStock: true,
          categoryId: 'c1',
          categoryName: 'Lilies',
          imageUrl: 'url1',
        ),
      ],
    );

    test(
      'should return SuccessResponse<List<ProductEntity>> when remote call succeeds',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getProductsByOccasion(tOccasionId),
        ).thenAnswer((_) async => tProductsDto);

        // Act
        final result = await repository.getProductsByOccasion(tOccasionId);

        // Assert
        expect(result, isA<SuccessResponse<List<ProductEntity>>>());
        final data = (result as SuccessResponse<List<ProductEntity>>).data;
        expect(data?.first.id, 'p1');
        expect(data?.first.name, 'Lily Bouquet');
        verify(
          mockRemoteDataSource.getProductsByOccasion(tOccasionId),
        ).called(1);
      },
    );

    test('should return ErrorResponse when remote call fails', () async {
      // Arrange
      when(
        mockRemoteDataSource.getProductsByOccasion(tOccasionId),
      ).thenThrow(Exception('Server error'));

      // Act
      final result = await repository.getProductsByOccasion(tOccasionId);

      // Assert
      expect(result, isA<ErrorResponse<List<ProductEntity>>>());
      verify(mockRemoteDataSource.getProductsByOccasion(tOccasionId)).called(1);
    });
  });
}
