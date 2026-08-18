import 'package:flowrist/features/home/categories/data/mapper/categories_mapper.dart';
import 'package:flowrist/features/home/categories/data/models/response/categories_response_dto.dart';
import 'package:flowrist/features/home/categories/data/models/response/category_products_response_dto.dart';
import 'package:flowrist/features/home/categories/domain/entities/category_entity.dart';
import 'package:flowrist/features/home/categories/domain/entities/category_product_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CategoriesMapper - toCategoryEntities', () {
    test(
      'should map CategoriesResponseDto to List<CategoryEntity> correctly',
      () {
        // Arrange
        const dto = CategoriesResponseDto(
          data: [
            CategoryDto(
              id: '1',
              name: 'Roses',
              iconUrl: 'https://img.com/roses',
            ),
            CategoryDto(
              id: '2',
              name: 'Tulips',
              iconUrl: 'https://img.com/tulips',
            ),
          ],
        );

        // Act
        final result = CategoriesMapper.toCategoryEntities(dto);

        // Assert
        expect(result.length, 2);
        expect(result, const [
          CategoryEntity(
            id: '1',
            name: 'Roses',
            iconUrl: 'https://img.com/roses',
          ),
          CategoryEntity(
            id: '2',
            name: 'Tulips',
            iconUrl: 'https://img.com/tulips',
          ),
        ]);
      },
    );

    test('should handle null fields in CategoryDto with fallback defaults', () {
      // Arrange
      const dto = CategoriesResponseDto(
        data: [CategoryDto(id: null, name: null, iconUrl: null)],
      );

      // Act
      final result = CategoriesMapper.toCategoryEntities(dto);

      // Assert
      expect(result.length, 1);
      expect(result.first.id, '');
      expect(result.first.name, '');
      expect(result.first.iconUrl, '');
    });

    test('should return empty list when data is null', () {
      // Arrange
      const dto = CategoriesResponseDto(data: null);

      // Act
      final result = CategoriesMapper.toCategoryEntities(dto);

      // Assert
      expect(result, isEmpty);
    });
  });

  group('CategoriesMapper - toProductEntities', () {
    test(
      'should map CategoryProductsResponseDto to List<CategoryProductEntity> correctly',
      () {
        // Arrange
        const dto = CategoryProductsResponseDto(
          data: [
            CategoryProductDto(
              id: 'p1',
              name: 'Petite Posy',
              price: 24.0,
              inStock: true,
              categoryId: 'c1',
              categoryName: 'Bouquets',
              imageUrl: 'https://img.com/posy',
            ),
          ],
        );

        // Act
        final result = CategoriesMapper.toProductEntities(dto);

        // Assert
        expect(result.length, 1);
        expect(result, const [
          CategoryProductEntity(
            id: 'p1',
            name: 'Petite Posy',
            price: 24.0,
            inStock: true,
            categoryId: 'c1',
            categoryName: 'Bouquets',
            imageUrl: 'https://img.com/posy',
          ),
        ]);
      },
    );

    test(
      'should handle null fields in CategoryProductDto with fallback defaults',
      () {
        // Arrange
        const dto = CategoryProductsResponseDto(
          data: [
            CategoryProductDto(
              id: null,
              name: null,
              price: null,
              inStock: null,
              categoryId: null,
              categoryName: null,
              imageUrl: null,
            ),
          ],
        );

        // Act
        final result = CategoriesMapper.toProductEntities(dto);

        // Assert
        expect(result.length, 1);
        expect(result.first.id, '');
        expect(result.first.name, '');
        expect(result.first.price, 0.0);
        expect(result.first.inStock, false);
        expect(result.first.categoryId, '');
        expect(result.first.categoryName, '');
        expect(result.first.imageUrl, '');
      },
    );

    test('should return empty list when products data is null', () {
      // Arrange
      const dto = CategoryProductsResponseDto(data: null);

      // Act
      final result = CategoriesMapper.toProductEntities(dto);

      // Assert
      expect(result, isEmpty);
    });
  });
}
