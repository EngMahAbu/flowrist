import 'package:flutter_test/flutter_test.dart';
import 'package:flowrist/features/home/home/data/mapper/occasions_mapper.dart';
import 'package:flowrist/features/home/home/data/models/response/occasions_response_dto.dart';
import 'package:flowrist/features/home/home/data/models/response/products_response_dto.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion_entity.dart';
import 'package:flowrist/features/home/home/domain/entities/product_entity.dart';

void main() {
  group('OccasionsMapper - toOccasionEntities', () {
    test(
      'should map OccasionsResponseDto to List<OccasionEntity> correctly',
      () {
        // Arrange
        const dto = OccasionsResponseDto(
          data: [
            OccasionDto(
              id: '1',
              name: 'Birthday',
              imageUrl: 'https://img.com/1',
            ),
            OccasionDto(
              id: '2',
              name: 'Wedding',
              imageUrl: 'https://img.com/2',
            ),
          ],
        );

        // Act
        final result = OccasionsMapper.toOccasionEntities(dto);

        // Assert
        expect(result.length, 2);
        expect(result, const [
          OccasionEntity(
            id: '1',
            name: 'Birthday',
            imageUrl: 'https://img.com/1',
          ),
          OccasionEntity(
            id: '2',
            name: 'Wedding',
            imageUrl: 'https://img.com/2',
          ),
        ]);
      },
    );

    test('should return list with fallback defaults when fields are null', () {
      // Arrange
      const dto = OccasionsResponseDto(
        data: [OccasionDto(id: null, name: null, imageUrl: null)],
      );

      // Act
      final result = OccasionsMapper.toOccasionEntities(dto);

      // Assert
      expect(result.length, 1);
      expect(result.first.id, '');
      expect(result.first.name, '');
      expect(result.first.imageUrl, '');
    });

    test('should return empty list when data is null', () {
      // Arrange
      const dto = OccasionsResponseDto(data: null);

      // Act
      final result = OccasionsMapper.toOccasionEntities(dto);

      // Assert
      expect(result, isEmpty);
    });
  });

  group('OccasionsMapper - toProductEntities', () {
    test('should map ProductsResponseDto to List<ProductEntity> correctly', () {
      // Arrange
      const dto = ProductsResponseDto(
        data: [
          ProductDto(
            id: 'p1',
            name: 'Rose',
            price: 25.5,
            inStock: true,
            categoryId: 'c1',
            categoryName: 'Roses',
            imageUrl: 'https://img.com/p1',
          ),
        ],
      );

      // Act
      final result = OccasionsMapper.toProductEntities(dto);

      // Assert
      expect(result.length, 1);
      expect(result, const [
        ProductEntity(
          id: 'p1',
          name: 'Rose',
          price: 25.5,
          inStock: true,
          categoryId: 'c1',
          categoryName: 'Roses',
          imageUrl: 'https://img.com/p1',
        ),
      ]);
    });

    test('should return empty list when products data is null', () {
      // Arrange
      const dto = ProductsResponseDto(data: null);

      // Act
      final result = OccasionsMapper.toProductEntities(dto);

      // Assert
      expect(result, isEmpty);
    });
  });
}
