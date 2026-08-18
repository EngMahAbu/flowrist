import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/domain/entities/product_entity.dart';
import 'package:flowrist/features/home/home/domain/repositories/occasions_repository.dart';
import 'package:flowrist/features/home/home/domain/use_cases/get_products_by_occasion_use_case.dart';

import 'get_products_by_occasion_use_case_test.mocks.dart';

@GenerateMocks([OccasionsRepository])
void main() {
  late GetProductsByOccasionUseCase useCase;
  late MockOccasionsRepository mockRepository;

  setUpAll(() {
    provideDummy<BaseResponse<List<ProductEntity>>>(
      SuccessResponse<List<ProductEntity>>([]),
    );
  });

  setUp(() {
    mockRepository = MockOccasionsRepository();
    useCase = GetProductsByOccasionUseCase(mockRepository);
  });

  const tOccasionId = 'occ-123';
  const tProducts = [
    ProductEntity(
      id: 'p1',
      name: 'Rose Bouquet',
      price: 50.0,
      inStock: true,
      categoryId: 'c1',
      categoryName: 'Roses',
      imageUrl: 'url1',
    ),
  ];

  test('should return SuccessResponse with List<ProductEntity> when repository succeeds', () async {
    // Arrange
    when(mockRepository.getProductsByOccasion(tOccasionId))
        .thenAnswer((_) async => SuccessResponse(tProducts));

    // Act
    final result = await useCase(tOccasionId);

    // Assert
    expect(result, isA<SuccessResponse<List<ProductEntity>>>());
    expect((result as SuccessResponse<List<ProductEntity>>).data, tProducts);
    verify(mockRepository.getProductsByOccasion(tOccasionId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ErrorResponse when repository fails', () async {
    // Arrange
    when(mockRepository.getProductsByOccasion(tOccasionId))
        .thenAnswer((_) async => ErrorResponse('Products not found'));

    // Act
    final result = await useCase(tOccasionId);

    // Assert
    expect(result, isA<ErrorResponse<List<ProductEntity>>>());
    expect((result as ErrorResponse<List<ProductEntity>>).errorMessage, 'Products not found');
    verify(mockRepository.getProductsByOccasion(tOccasionId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}