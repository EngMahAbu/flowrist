import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/categories/domain/entities/category_entity.dart';
import 'package:flowrist/features/home/categories/domain/repositories/categories_repository.dart';
import 'package:flowrist/features/home/categories/domain/use_cases/get_categories_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_categories_use_case_test.mocks.dart';

@GenerateMocks([CategoriesRepository])
void main() {
  late GetCategoriesUseCase useCase;
  late MockCategoriesRepository mockRepository;

  setUpAll(() {
    provideDummy<BaseResponse<List<CategoryEntity>>>(
      SuccessResponse<List<CategoryEntity>>([]),
    );
  });

  setUp(() {
    mockRepository = MockCategoriesRepository();
    useCase = GetCategoriesUseCase(mockRepository);
  });

  const tCategories = [
    CategoryEntity(id: '1', name: 'Roses', iconUrl: 'icon1'),
    CategoryEntity(id: '2', name: 'Tulips', iconUrl: 'icon2'),
  ];

  test(
    'should return SuccessResponse with List<CategoryEntity> when repository succeeds',
    () async {
      // Arrange
      when(
        mockRepository.getCategories(),
      ).thenAnswer((_) async => SuccessResponse(tCategories));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<SuccessResponse<List<CategoryEntity>>>());
      expect(
        (result as SuccessResponse<List<CategoryEntity>>).data,
        tCategories,
      );
      verify(mockRepository.getCategories()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return ErrorResponse when repository fails', () async {
    // Arrange
    when(
      mockRepository.getCategories(),
    ).thenAnswer((_) async => ErrorResponse('Failed to load categories'));

    // Act
    final result = await useCase();

    // Assert
    expect(result, isA<ErrorResponse<List<CategoryEntity>>>());
    expect(
      (result as ErrorResponse<List<CategoryEntity>>).errorMessage,
      'Failed to load categories',
    );
    verify(mockRepository.getCategories()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
