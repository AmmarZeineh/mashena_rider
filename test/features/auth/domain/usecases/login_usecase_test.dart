import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/auth/domain/entities/auth_session.dart';
import 'package:mashena_rider/features/auth/domain/entities/user.dart';
import 'package:mashena_rider/features/auth/domain/repositories/auth_repository.dart';
import 'package:mashena_rider/features/auth/domain/usecases/login_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LoginUsecase(mockRepository);
  });
  final String email = 'test@test.com';
  final String password = '123456';
  final String fcmToken = 'token';

  final session = AuthSession(
    accessToken: 'accessToken',
    user: User(
      id: 0,
      email: email,
      phoneNumber: '0900000000',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );

  test('should return AuthSession when repository succeeds', () async {
    when(
      () => mockRepository.login(
        email: email,
        password: password,
        fcmToken: fcmToken,
      ),
    ).thenAnswer((_) async => Right(session));

    final result = await usecase(
      email: email,
      password: password,
      fcmToken: fcmToken,
    );

    expect(result, Right(session));
    verify(
      () => mockRepository.login(
        email: email,
        password: password,
        fcmToken: fcmToken,
      ),
    ).called(1);
  });

  test('should return Failure when repository fails', () async {
    final failure = Failure(FailureCode.unauthorized);

    when(
      () => mockRepository.login(
        email: email,
        password: password,
        fcmToken: fcmToken,
      ),
    ).thenAnswer((_) async => Left(failure));

    final result = await usecase(
      email: email,
      fcmToken: fcmToken,
      password: password,
    );

    expect(result, Left(failure));
  });
}
