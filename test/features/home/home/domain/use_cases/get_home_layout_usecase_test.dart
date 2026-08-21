import 'package:flowrist/features/home/home/domain/use_cases/get_home_layout_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/domain/entities/home_entities/home_layout_entity.dart';
import 'package:flowrist/features/home/home/domain/repositories/home_repository.dart';

import 'get_home_layout_usecase_test.mocks.dart';
 
@GenerateMocks([HomeRepository])
void main() {
  late MockHomeRepository mockRepository;
  late GetHomeLayoutUseCase useCase;
provideDummy<BaseResponse<List<HomeLayoutEntity>>>(
  SuccessResponse<List<HomeLayoutEntity>>([]),
);
  setUp(() {
    mockRepository = MockHomeRepository();
    useCase = GetHomeLayoutUseCase(mockRepository);
  });

  group('GetHomeLayoutUseCase', () {
    test(
      'should call repository.getHomeLayout and return its response',
      () async {
        // Arrange
        final response = SuccessResponse<List<HomeLayoutEntity>>([]);

        when(mockRepository.getHomeLayout()).thenAnswer(
          (_) async => response,
        );

        // Act
        final result = await useCase();

        // Assert
        expect(result, same(response));

        verify(mockRepository.getHomeLayout()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return ErrorResponse when repository returns an error',
      () async {
        // Arrange
        const errorMessage = 'Failed to load home layout';

        final response = ErrorResponse<List<HomeLayoutEntity>>(
          errorMessage,
        );

        when(mockRepository.getHomeLayout()).thenAnswer(
          (_) async => response,
        );

        // Act
        final result = await useCase();

        // Assert
        expect(result, same(response));

        expect(
          result,
          isA<ErrorResponse<List<HomeLayoutEntity>>>(),
        );

        final errorResponse =
            result as ErrorResponse<List<HomeLayoutEntity>>;

        expect(errorResponse.errorMessage, errorMessage);

        verify(mockRepository.getHomeLayout()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}