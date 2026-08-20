import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/home/domain/entities/trip_share.dart';
import 'package:mashena_rider/features/home/domain/usecases/revoke_share_trip_usecase.dart';
import 'package:mashena_rider/features/home/domain/usecases/share_trip_usecase.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/trip_share_cubit/trip_share_cubit.dart';

class MockShareTripUsecase extends Mock implements ShareTripUsecase {}
class MockRevokeShareTripUsecase extends Mock implements RevokeShareTripUsecase {}

void main() {
  late MockShareTripUsecase mockShareTrip;
  late MockRevokeShareTripUsecase mockRevokeShareTrip;
  late TripShareCubit tripShareCubit;

  const testTripShare = TripShare(
    shareId: 101,
    shareUrl: 'https://mashena.sy/share/test_token',
    status: 'active',
  );

  setUp(() {
    mockShareTrip = MockShareTripUsecase();
    mockRevokeShareTrip = MockRevokeShareTripUsecase();
    tripShareCubit = TripShareCubit(mockShareTrip, mockRevokeShareTrip);
  });

  tearDown(() {
    tripShareCubit.close();
  });

  group('TripShareCubit', () {
    test('initial state is TripShareInitial', () {
      expect(tripShareCubit.state, const TripShareInitial());
    });

    test('shareTrip emits [TripShareLoading, TripShareLoaded] on success', () async {
      when(() => mockShareTrip(50)).thenAnswer((_) async => const Right(testTripShare));

      final expected = [
        const TripShareLoading(),
        const TripShareLoaded(testTripShare),
      ];

      expectLater(tripShareCubit.stream, emitsInOrder(expected));

      await tripShareCubit.shareTrip(50);
      verify(() => mockShareTrip(50)).called(1);
    });

    test('shareTrip emits [TripShareLoading, TripShareError] on failure', () async {
      when(() => mockShareTrip(50)).thenAnswer(
        (_) async => const Left(Failure(FailureCode.unknown, rawMessage: 'Share link error')),
      );

      final expected = [
        const TripShareLoading(),
        const TripShareError('Share link error'),
      ];

      expectLater(tripShareCubit.stream, emitsInOrder(expected));

      await tripShareCubit.shareTrip(50);
    });

    test('revokeShareTrip emits [TripShareRevoking, TripShareInitial] on success', () async {
      when(() => mockShareTrip(50)).thenAnswer((_) async => const Right(testTripShare));
      when(() => mockRevokeShareTrip(50)).thenAnswer((_) async => const Right(true));

      await tripShareCubit.shareTrip(50);

      final expected = [
        const TripShareRevoking(testTripShare),
        const TripShareInitial(),
      ];

      expectLater(tripShareCubit.stream, emitsInOrder(expected));

      await tripShareCubit.revokeShareTrip(50);
      verify(() => mockRevokeShareTrip(50)).called(1);
    });

    test('reset emits TripShareInitial', () async {
      tripShareCubit.reset();
      expect(tripShareCubit.state, const TripShareInitial());
    });
  });
}
