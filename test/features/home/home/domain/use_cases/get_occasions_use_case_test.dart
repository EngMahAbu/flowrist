import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion_entity.dart';
import 'package:flowrist/features/home/home/domain/repositories/occasions_repository.dart';
import 'package:flowrist/features/home/home/domain/use_cases/get_occasions_use_case.dart';

import 'get_occasions_use_case_test.mocks.dart';

@GenerateMocks([OccasionsRepository])
void main() {
  late GetOccasionsUseCase useCase;
  late MockOccasionsRepository mockRepository;

  setUpAll(() {
    provideDummy<BaseResponse<List<OccasionEntity>>>(
      SuccessResponse<List<OccasionEntity>>([]),
    );
  });

  setUp(() {
    mockRepository = MockOccasionsRepository();
    useCase = GetOccasionsUseCase(mockRepository);
  });

  const tOccasions = [
    OccasionEntity(id: '1', name: 'Birthday', imageUrl: 'url1'),
    OccasionEntity(id: '2', name: 'Wedding', imageUrl: 'url2'),
  ];

  test(
    'should return SuccessResponse with List<OccasionEntity> when repository succeeds',
    () async {
      // Arrange
      when(
        mockRepository.getOccasions(),
      ).thenAnswer((_) async => SuccessResponse(tOccasions));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<SuccessResponse<List<OccasionEntity>>>());
      expect(
        (result as SuccessResponse<List<OccasionEntity>>).data,
        tOccasions,
      );
      verify(mockRepository.getOccasions()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return ErrorResponse when repository returns an error',
    () async {
      // Arrange
      when(
        mockRepository.getOccasions(),
      ).thenAnswer((_) async => ErrorResponse('Server Error'));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<ErrorResponse<List<OccasionEntity>>>());
      expect(
        (result as ErrorResponse<List<OccasionEntity>>).errorMessage,
        'Server Error',
      );
      verify(mockRepository.getOccasions()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
