import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/categories/data/data_sources/contract/remote/categories_remote_data_source.dart';
import 'package:flowrist/features/home/categories/data/models/response/categories_response_dto.dart';
import 'package:flowrist/features/home/categories/data/models/response/category_products_response_dto.dart';
import 'package:flowrist/features/home/categories/data/repositories/categories_repository_impl.dart';
import 'package:flowrist/features/home/categories/domain/entities/category_entity.dart';
import 'package:flowrist/features/home/categories/domain/entities/category_product_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'categories_repository_impl_test.mocks.dart';

@GenerateMocks([CategoriesRemoteDataSource])
void main() {
  late CategoriesRepositoryImpl repository;
  late MockCategoriesRemoteDataSource mockRemoteDataSource;

  setUpAll(() {
    provideDummy<CategoriesResponseDto>(const CategoriesResponseDto());
    provideDummy<CategoryProductsResponseDto>(
      const CategoryProductsResponseDto(),
    );
  });

  setUp(() {
    mockRemoteDataSource = MockCategoriesRemoteDataSource();
    repository = CategoriesRepositoryImpl(mockRemoteDataSource);
  });

  group('getCategories', () {
    const tResponseDto = CategoriesResponseDto(
      data: [CategoryDto(id: '1', name: 'Roses', iconUrl: 'icon1')],
    );

    test(
      'should return SuccessResponse<List<CategoryEntity>> when remote call succeeds',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getCategories(),
        ).thenAnswer((_) async => tResponseDto);

        // Act
        final result = await repository.getCategories();

        // Assert
        expect(result, isA<SuccessResponse<List<CategoryEntity>>>());
        final data = (result as SuccessResponse<List<CategoryEntity>>).data;
        expect(data?.first.id, '1');
        expect(data?.first.name, 'Roses');
        verify(mockRemoteDataSource.getCategories()).called(1);
      },
    );

    test(
      'should return ErrorResponse when remote data source throws an exception',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getCategories(),
        ).thenThrow(Exception('Connection error'));

        // Act
        final result = await repository.getCategories();

        // Assert
        expect(result, isA<ErrorResponse<List<CategoryEntity>>>());
        verify(mockRemoteDataSource.getCategories()).called(1);
      },
    );
  });

  group('getProductsByCategory', () {
    const tCategoryId = 'cat-123';
    const tProductsDto = CategoryProductsResponseDto(
      data: [
        CategoryProductDto(
          id: 'p1',
          name: 'Bouquet',
          price: 30.0,
          inStock: true,
          categoryId: 'cat-123',
          categoryName: 'Roses',
          imageUrl: 'url1',
        ),
      ],
    );

    test(
      'should return SuccessResponse<List<CategoryProductEntity>> when remote call succeeds',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getProductsByCategory(tCategoryId),
        ).thenAnswer((_) async => tProductsDto);

        // Act
        final result = await repository.getProductsByCategory(tCategoryId);

        // Assert
        expect(result, isA<SuccessResponse<List<CategoryProductEntity>>>());
        final data =
            (result as SuccessResponse<List<CategoryProductEntity>>).data;
        expect(data?.first.id, 'p1');
        expect(data?.first.name, 'Bouquet');
        verify(
          mockRemoteDataSource.getProductsByCategory(tCategoryId),
        ).called(1);
      },
    );

    test('should return ErrorResponse when remote call fails', () async {
      // Arrange
      when(
        mockRemoteDataSource.getProductsByCategory(tCategoryId),
      ).thenThrow(Exception('Server error'));

      // Act
      final result = await repository.getProductsByCategory(tCategoryId);

      // Assert
      expect(result, isA<ErrorResponse<List<CategoryProductEntity>>>());
      verify(mockRemoteDataSource.getProductsByCategory(tCategoryId)).called(1);
    });
  });
}
