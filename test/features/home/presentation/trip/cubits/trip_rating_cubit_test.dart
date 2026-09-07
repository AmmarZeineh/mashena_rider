import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mashena_rider/core/constants/app_constants.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/home/domain/entities/rating_tag.dart';
import 'package:mashena_rider/features/home/domain/entities/trip_wallet_payment_entity.dart';
import 'package:mashena_rider/features/home/domain/repositories/rating_repository.dart';
import 'package:mashena_rider/features/home/domain/usecases/pay_trip_with_wallet_usecase.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/trip_rating_cubit.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/trip_rating_state.dart';
import 'package:mashena_rider/features/wallet/domain/entities/wallet_entity.dart';
import 'package:mashena_rider/features/wallet/domain/usecases/get_my_wallet_usecase.dart';

class MockRatingRepository extends Mock implements RatingRepository {}

class MockPayTripWithWalletUsecase extends Mock
    implements PayTripWithWalletUsecase {}

class MockGetMyWalletUsecase extends Mock implements GetMyWalletUsecase {}

void main() {
  late MockRatingRepository mockRepo;
  late MockPayTripWithWalletUsecase mockPayWalletUsecase;
  late MockGetMyWalletUsecase mockGetWalletUsecase;
  late TripRatingCubit cubit;

  const testPosTag = RatingTag(id: 1, code: 'clean_car', name: 'Clean Car');
  const testNegTag = RatingTag(id: 2, code: 'late_arrival', name: 'Late');

  const testWallet = WalletEntity(
    id: 1,
    userId: 10,
    balance: 15000.0,
    currency: 'SYP',
    status: 'ACTIVE',
  );

  const testPayment = TripWalletPaymentEntity(
    tripId: 42,
    amount: 3500,
    riderBalanceAfter: 11500,
    driverUserId: 5,
    transferId: 101,
  );

  setUp(() {
    mockRepo = MockRatingRepository();
    mockPayWalletUsecase = MockPayTripWithWalletUsecase();
    mockGetWalletUsecase = MockGetMyWalletUsecase();

    when(
      () => mockRepo.getTags(targetType: 'DRIVER', sentiment: 'POSITIVE'),
    ).thenAnswer((_) async => const Right([testPosTag]));

    when(
      () => mockRepo.getTags(targetType: 'DRIVER', sentiment: 'NEGATIVE'),
    ).thenAnswer((_) async => const Right([testNegTag]));

    when(
      () => mockGetWalletUsecase(),
    ).thenAnswer((_) async => const Right(testWallet));

    cubit = TripRatingCubit(
      mockRepo,
      payTripWithWalletUsecase: mockPayWalletUsecase,
      getMyWalletUsecase: mockGetWalletUsecase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('TripRatingCubit', () {
    test(
      'fetches tags and wallet balance on instantiation and populates state',
      () async {
        await pumpEventQueue();
        expect(cubit.state.positiveTags, [testPosTag]);
        expect(cubit.state.negativeTags, [testNegTag]);
        expect(cubit.state.walletBalance, 15000.0);
        expect(cubit.state.paymentMethod, TripPaymentMethod.cash);
      },
    );

    test('selectPaymentMethod switches paymentMethod in state', () {
      expect(cubit.state.paymentMethod, TripPaymentMethod.cash);

      cubit.selectPaymentMethod(TripPaymentMethod.wallet);
      expect(cubit.state.paymentMethod, TripPaymentMethod.wallet);

      cubit.selectPaymentMethod(TripPaymentMethod.cash);
      expect(cubit.state.paymentMethod, TripPaymentMethod.cash);
    });

    test(
      'payWithWallet emits isPayingWithWallet then success with updated balance',
      () async {
        when(
          () => mockPayWalletUsecase(any()),
        ).thenAnswer((_) async => const Right(testPayment));

        final expectedStates = [
          predicate<TripRatingState>(
            (s) => s.isPayingWithWallet == true && s.paymentError == null,
          ),
          predicate<TripRatingState>(
            (s) =>
                s.isPayingWithWallet == false &&
                s.isWalletPaid == true &&
                s.walletBalance == 11500 &&
                s.walletPaymentResult == testPayment,
          ),
        ];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        await cubit.payWithWallet(100);

        verify(() => mockPayWalletUsecase(100)).called(1);
      },
    );

    test('payWithWallet emits paymentError on failure', () async {
      when(() => mockPayWalletUsecase(any())).thenAnswer(
        (_) async => const Left(
          Failure(FailureCode.server, rawMessage: 'Insufficient funds'),
        ),
      );

      final expectedStates = [
        predicate<TripRatingState>((s) => s.isPayingWithWallet == true),
        predicate<TripRatingState>(
          (s) =>
              s.isPayingWithWallet == false &&
              s.paymentError != null &&
              s.isWalletPaid == false,
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.payWithWallet(100);
    });

    test(
      'setScore clears tags when sentiment flips between positive and negative',
      () async {
        await pumpEventQueue();

        cubit.setScore(5.0); // positive
        cubit.toggleTag(1);
        expect(cubit.state.selectedTagIds, {1});

        cubit.setScore(2.0); // negative - sentiment changed!
        expect(cubit.state.selectedTagIds, isEmpty);
      },
    );

    test('toggleTag adds and removes tags from selection', () {
      cubit.toggleTag(1);
      expect(cubit.state.selectedTagIds, {1});

      cubit.toggleTag(2);
      expect(cubit.state.selectedTagIds, {1, 2});

      cubit.toggleTag(1);
      expect(cubit.state.selectedTagIds, {2});
    });

    test('submitRating sets validationError when score is 0', () async {
      await cubit.submitRating(tripId: 10, comment: 'Great');

      expect(cubit.state.validationError, AppConstants.errorSelectRatingScore);
    });

    test('submitRating sets validationError when no tags selected', () async {
      cubit.setScore(4.0);
      await cubit.submitRating(tripId: 10, comment: 'Great');

      expect(cubit.state.validationError, AppConstants.errorSelectRatingTag);
    });

    test('submitRating succeeds and emits isSuccess true', () async {
      when(
        () => mockRepo.submitRating(
          tripId: any(named: 'tripId'),
          score: any(named: 'score'),
          comment: any(named: 'comment'),
          tagIds: any(named: 'tagIds'),
        ),
      ).thenAnswer((_) async => const Right(null));

      cubit.setScore(5.0);
      cubit.toggleTag(1);

      await cubit.submitRating(tripId: 10, comment: 'Nice driver');

      expect(cubit.state.isSuccess, isTrue);
    });
  });
}
