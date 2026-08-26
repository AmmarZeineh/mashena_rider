import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/coupons/domain/entities/coupon_entity.dart';
import 'package:mashena_rider/features/coupons/domain/entities/user_coupon_entity.dart';
import 'package:mashena_rider/features/coupons/domain/repositories/coupons_repository.dart';
import 'package:mashena_rider/features/coupons/presentation/cubits/coupons_cubit.dart';
import 'package:mashena_rider/features/coupons/presentation/cubits/coupons_state.dart';

class MockCouponsRepository extends Mock implements CouponsRepository {}

void main() {
  late MockCouponsRepository mockRepo;
  late CouponsCubit cubit;

  const testCoupon = CouponEntity(
    id: 1,
    code: 'MASHENA50',
    name: '50% Off',
    discountType: 'PERCENTAGE',
    discountValue: 50.0,
    isActive: true,
  );

  final testUserCoupon = UserCouponEntity(
    id: 10,
    userId: 1,
    couponId: 1,
    remainingUsages: 3,
    status: 'ACTIVE',
    coupon: testCoupon,
  );

  setUp(() {
    mockRepo = MockCouponsRepository();
    cubit = CouponsCubit(mockRepo);
  });

  tearDown(() {
    cubit.close();
  });

  group('CouponsCubit', () {
    test('initial state has CouponsStatus.initial', () {
      expect(cubit.state.status, CouponsStatus.initial);
      expect(cubit.state.activeCoupons, isEmpty);
    });

    test(
      'fetchAllData emits loading then loaded with active coupons and history',
      () async {
        when(
          () => mockRepo.getMyCoupons(),
        ).thenAnswer((_) async => Right([testUserCoupon]));
        when(
          () => mockRepo.getMyHistory(),
        ).thenAnswer((_) async => const Right([]));

        final expectedStates = [
          predicate<CouponsState>((s) => s.status == CouponsStatus.loading),
          predicate<CouponsState>(
            (s) =>
                s.status == CouponsStatus.loaded &&
                s.activeCoupons.length == 1 &&
                s.activeCoupons.first.coupon.code == 'MASHENA50',
          ),
        ];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        await cubit.fetchAllData();
      },
    );

    test(
      'activateCoupon emits loading then success with added coupon',
      () async {
        when(
          () => mockRepo.activateCoupon('MASHENA50'),
        ).thenAnswer((_) async => Right(testUserCoupon));

        final expectedStates = [
          predicate<CouponsState>(
            (s) => s.activationStatus == ActivationStatus.loading,
          ),
          predicate<CouponsState>(
            (s) =>
                s.activationStatus == ActivationStatus.success &&
                s.activeCoupons.contains(testUserCoupon),
          ),
        ];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        await cubit.activateCoupon('MASHENA50');
      },
    );

    test('activateCoupon emits error on invalid code', () async {
      when(() => mockRepo.activateCoupon('INVALID')).thenAnswer(
        (_) async => const Left(
          Failure(FailureCode.validation, rawMessage: 'Invalid code'),
        ),
      );

      final expectedStates = [
        predicate<CouponsState>(
          (s) => s.activationStatus == ActivationStatus.loading,
        ),
        predicate<CouponsState>(
          (s) =>
              s.activationStatus == ActivationStatus.error &&
              s.activationFailure?.rawMessage == 'Invalid code',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.activateCoupon('INVALID');
    });

    test('resetActivationState resets activationStatus to initial', () async {
      when(
        () => mockRepo.activateCoupon('MASHENA50'),
      ).thenAnswer((_) async => Right(testUserCoupon));
      await cubit.activateCoupon('MASHENA50');

      cubit.resetActivationState();

      expect(cubit.state.activationStatus, ActivationStatus.initial);
    });
  });
}
