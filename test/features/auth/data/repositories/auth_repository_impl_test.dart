import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/storage/secure_storage_service.dart';
import 'package:flowrist/features/auth/data/data_sources/contract/remote/auth_remote_data_source.dart';
import 'package:flowrist/features/auth/data/models/register_request_dto.dart';
import 'package:flowrist/features/auth/data/models/register_response_dto.dart';
import 'package:flowrist/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flowrist/features/auth/domain/entities/user_entity.dart';

@GenerateMocks([AuthRemoteDataSource, SecureStorageService])
import 'auth_repository_impl_test.mocks.dart';

void main() {
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockSecureStorageService mockSecureStorageService;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockSecureStorageService = MockSecureStorageService();
    repository = AuthRepositoryImpl(
      mockRemoteDataSource,
      mockSecureStorageService,
    );
  });

  const tRequestDto = RegisterRequestDto(
    firstName: 'Ali',
    lastName: 'Ibrahim',
    email: 'ali@example.com',
    phone: '01000000000',
    gender: 0,
    password: 'Password123!',
    confirmPassword: 'Password123!',
    fcmToken: 'token',
    notificationStatus: 1,
  );

  const tUserDto = UserDto(
    id: '123',
    name: 'Ali Ibrahim',
    email: 'ali@example.com',
    phone: '01000000000',
  );

  const tResponseDto = RegisterResponseDto(
    message: 'Success',
    data: RegisterDataDto(user: tUserDto, token: 'jwt_token_example'),
  );

  group('AuthRepositoryImpl Unit Tests', () {
    test(
      'should return SuccessResponse<UserEntity> when remote call is successful',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.register(any),
        ).thenAnswer((_) async => tResponseDto);

        // Act
        final result = await repository.register(tRequestDto);

        // Assert
        expect(result, isA<SuccessResponse<UserEntity>>());
        final successData = (result as SuccessResponse<UserEntity>).data;
        expect(successData?.id, equals('123'));
        verify(mockRemoteDataSource.register(tRequestDto)).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return FailureResponse when remote call throws an exception',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.register(any),
        ).thenThrow(Exception('Server error'));

        // Act
        final result = await repository.register(tRequestDto);

        // Assert
        expect(result, isNot(isA<SuccessResponse<UserEntity>>()));
        verify(mockRemoteDataSource.register(tRequestDto)).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });
}