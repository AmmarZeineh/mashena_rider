import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mashena_rider/core/auth/auth_event.dart';
import 'package:mashena_rider/core/auth/auth_event_bus.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/auth/domain/entities/auth_session.dart';
import 'package:mashena_rider/features/auth/domain/entities/user.dart';
import 'package:mashena_rider/features/auth/domain/usecases/get_cached_session_usecase.dart';
import 'package:mashena_rider/features/auth/domain/usecases/logout_usecase.dart';
import 'package:mashena_rider/features/auth/presentation/blocs/auth_cubit/auth_cubit.dart';

class MockGetCachedSessionUsecase extends Mock
    implements GetCachedSessionUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

void main() {
  late MockGetCachedSessionUsecase mockGetCached;
  late MockLogoutUsecase mockLogout;
  late AuthEventBus authEventBus;
  late AuthCubit authCubit;

  final testUser = User(
    id: 1,
    fullName: 'Test Rider',
    email: 'rider@mashena.com',
    phoneNumber: '0912345678',
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );

  final testSession = AuthSession(
    accessToken: 'test_access_token',
    user: testUser,
  );

  setUp(() {
    mockGetCached = MockGetCachedSessionUsecase();
    mockLogout = MockLogoutUsecase();
    authEventBus = AuthEventBus();
    authCubit = AuthCubit(mockGetCached, mockLogout, authEventBus);
  });

  tearDown(() {
    authCubit.close();
    authEventBus.dispose();
  });

  group('AuthCubit', () {
    test('initial state is AuthState.initial', () {
      expect(authCubit.state, const AuthState.initial());
    });

    test(
      'appStarted emits AuthState.authenticated when cached session is present',
      () async {
        when(() => mockGetCached()).thenAnswer((_) async => Right(testSession));

        final expectedStates = [AuthState.authenticated(testSession)];

        expectLater(authCubit.stream, emitsInOrder(expectedStates));

        await authCubit.appStarted();
      },
    );

    test(
      'appStarted emits AuthState.unauthenticated when no cached session is present',
      () async {
        when(
          () => mockGetCached(),
        ).thenAnswer((_) async => const Left(Failure(FailureCode.cache)));

        final expectedStates = [const AuthState.unauthenticated()];

        expectLater(authCubit.stream, emitsInOrder(expectedStates));

        await authCubit.appStarted();
      },
    );

    test('setSession directly transitions to AuthState.authenticated', () {
      authCubit.setSession(testSession);
      expect(authCubit.state, AuthState.authenticated(testSession));
    });

    test(
      'signOut calls LogoutUsecase and emits AuthState.unauthenticated',
      () async {
        when(
          () => mockLogout(allDevices: false),
        ).thenAnswer((_) async => const Right(unit));

        final expectedStates = [const AuthState.unauthenticated()];

        expectLater(authCubit.stream, emitsInOrder(expectedStates));

        await authCubit.signOut();
        verify(() => mockLogout(allDevices: false)).called(1);
      },
    );

    test(
      'listens to AuthEventBus loggedOut event and transitions to unauthenticated',
      () async {
        authCubit.setSession(testSession);

        final expectedStates = [const AuthState.unauthenticated()];

        expectLater(authCubit.stream, emitsInOrder(expectedStates));

        authEventBus.emit(AuthEvent.loggedOut);
      },
    );
  });
}
