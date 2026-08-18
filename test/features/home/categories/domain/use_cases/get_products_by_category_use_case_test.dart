import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/categories/domain/entities/category_product_entity.dart';
import 'package:flowrist/features/home/categories/domain/repositories/categories_repository.dart';
import 'package:flowrist/features/home/categories/domain/use_cases/get_products_by_category_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_products_by_category_use_case_test.mocks.dart';

@GenerateMocks([CategoriesRepository])
void main() {
  late GetProductsByCategoryUseCase useCase;
  late MockCategoriesRepository mockRepository;

  setUpAll(() {
    provideDummy<BaseResponse<List<CategoryProductEntity>>>(
      SuccessResponse<List<CategoryProductEntity>>([]),
    );
  });

  setUp(() {
    mockRepository = MockCategoriesRepository();
    useCase = GetProductsByCategoryUseCase(mockRepository);
  });

  const tCategoryId = 'cat-123';
  const tProducts = [
    CategoryProductEntity(
      id: 'p1',
      name: 'Red Rose',
      price: 20.0,
      inStock: true,
      categoryId: 'cat-123',
      categoryName: 'Roses',
      imageUrl: 'url1',
    ),
  ];

  test(
    'should return SuccessResponse with List<CategoryProductEntity> when repository succeeds',
    () async {
      // Arrange
      when(
        mockRepository.getProductsByCategory(tCategoryId),
      ).thenAnswer((_) async => SuccessResponse(tProducts));

      // Act
      final result = await useCase(tCategoryId);

      // Assert
      expect(result, isA<SuccessResponse<List<CategoryProductEntity>>>());
      expect(
        (result as SuccessResponse<List<CategoryProductEntity>>).data,
        tProducts,
      );
      verify(mockRepository.getProductsByCategory(tCategoryId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return ErrorResponse when repository fails', () async {
    // Arrange
    when(
      mockRepository.getProductsByCategory(tCategoryId),
    ).thenAnswer((_) async => ErrorResponse('Category products not found'));

    // Act
    final result = await useCase(tCategoryId);

    // Assert
    expect(result, isA<ErrorResponse<List<CategoryProductEntity>>>());
    expect(
      (result as ErrorResponse<List<CategoryProductEntity>>).errorMessage,
      'Category products not found',
    );
    verify(mockRepository.getProductsByCategory(tCategoryId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
