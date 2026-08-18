import 'package:flowrist/features/home/categories/data/client/categories_api_client.dart';
import 'package:flowrist/features/home/categories/data/data_sources/impl/remote/categories_remote_data_source_impl.dart';
import 'package:flowrist/features/home/categories/data/models/response/categories_response_dto.dart';
import 'package:flowrist/features/home/categories/data/models/response/category_products_response_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'categories_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([CategoriesApiClient])
void main() {
  late CategoriesRemoteDataSourceImpl dataSource;
  late MockCategoriesApiClient mockApiClient;

  setUpAll(() {
    provideDummy<CategoriesResponseDto>(const CategoriesResponseDto());
    provideDummy<CategoryProductsResponseDto>(
      const CategoryProductsResponseDto(),
    );
  });

  setUp(() {
    mockApiClient = MockCategoriesApiClient();
    dataSource = CategoriesRemoteDataSourceImpl(mockApiClient);
  });

  group('getCategories', () {
    const tResponseDto = CategoriesResponseDto(
      message: 'Success',
      data: [CategoryDto(id: '1', name: 'Roses')],
    );

    test(
      'should call apiClient.getCategories and return CategoriesResponseDto',
      () async {
        // Arrange
        when(
          mockApiClient.getCategories(),
        ).thenAnswer((_) async => tResponseDto);

        // Act
        final result = await dataSource.getCategories();

        // Assert
        expect(result, tResponseDto);
        verify(mockApiClient.getCategories()).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test('should throw an exception when apiClient fails', () async {
      // Arrange
      when(mockApiClient.getCategories()).thenThrow(Exception('API error'));

      // Act & Assert
      expect(() => dataSource.getCategories(), throwsA(isA<Exception>()));
      verify(mockApiClient.getCategories()).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });
  });

  group('getProductsByCategory', () {
    const tCategoryId = 'cat-123';
    const tProductsDto = CategoryProductsResponseDto(
      message: 'Success',
      data: [CategoryProductDto(id: 'p1', name: 'Rose Bouquet')],
    );

    test(
      'should call apiClient.getProductsByCategory with correct parameter',
      () async {
        // Arrange
        when(
          mockApiClient.getProductsByCategory(tCategoryId),
        ).thenAnswer((_) async => tProductsDto);

        // Act
        final result = await dataSource.getProductsByCategory(tCategoryId);

        // Assert
        expect(result, tProductsDto);
        verify(mockApiClient.getProductsByCategory(tCategoryId)).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test('should throw an exception when apiClient fails', () async {
      // Arrange
      when(
        mockApiClient.getProductsByCategory(tCategoryId),
      ).thenThrow(Exception('API error'));

      // Act & Assert
      expect(
        () => dataSource.getProductsByCategory(tCategoryId),
        throwsA(isA<Exception>()),
      );
      verify(mockApiClient.getProductsByCategory(tCategoryId)).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });
  });
}
