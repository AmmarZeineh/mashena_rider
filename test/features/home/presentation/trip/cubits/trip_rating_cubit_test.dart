import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mashena_rider/core/constants/app_constants.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/home/domain/entities/rating_tag.dart';
import 'package:mashena_rider/features/home/domain/repositories/rating_repository.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/trip_rating_cubit.dart';

class MockRatingRepository extends Mock implements RatingRepository {}

void main() {
  late MockRatingRepository mockRepo;
  late TripRatingCubit cubit;

  const testPosTag = RatingTag(id: 1, code: 'clean_car', name: 'Clean Car');
  const testNegTag = RatingTag(id: 2, code: 'late_arrival', name: 'Late');

  setUp(() {
    mockRepo = MockRatingRepository();

    when(
      () => mockRepo.getTags(targetType: 'DRIVER', sentiment: 'POSITIVE'),
    ).thenAnswer((_) async => const Right([testPosTag]));

    when(
      () => mockRepo.getTags(targetType: 'DRIVER', sentiment: 'NEGATIVE'),
    ).thenAnswer((_) async => const Right([testNegTag]));

    cubit = TripRatingCubit(mockRepo);
  });

  tearDown(() {
    cubit.close();
  });

  group('TripRatingCubit', () {
    test(
      'fetches tags on instantiation and populates positive/negative lists',
      () async {
        await pumpEventQueue();
        expect(cubit.state.positiveTags, [testPosTag]);
        expect(cubit.state.negativeTags, [testNegTag]);
      },
    );

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

    test(
      'submitRating sets validation error if score is 0 or no tags selected',
      () async {
        await pumpEventQueue();

        // No score
        await cubit.submitRating(tripId: 100, comment: null);
        expect(
          cubit.state.validationError,
          AppConstants.errorSelectRatingScore,
        );

        // Score set but no tag
        cubit.setScore(5.0);
        await cubit.submitRating(tripId: 100, comment: null);
        expect(cubit.state.validationError, AppConstants.errorSelectRatingTag);
      },
    );

    test(
      'submitRating submits to repository and sets isSuccess on success',
      () async {
        await pumpEventQueue();

        cubit.setScore(5.0);
        cubit.toggleTag(1);

        when(
          () => mockRepo.submitRating(
            tripId: 100,
            score: 5.0,
            comment: 'Great trip',
            tagIds: [1],
          ),
        ).thenAnswer((_) async => const Right(null));

        await cubit.submitRating(tripId: 100, comment: 'Great trip');

        expect(cubit.state.isSuccess, isTrue);
        expect(cubit.state.isSubmitting, isFalse);
      },
    );

    test('submitRating sets errorMessage on API failure', () async {
      await pumpEventQueue();

      cubit.setScore(5.0);
      cubit.toggleTag(1);

      when(
        () => mockRepo.submitRating(
          tripId: 100,
          score: 5.0,
          comment: 'Great trip',
          tagIds: [1],
        ),
      ).thenAnswer(
        (_) async => const Left(
          Failure(FailureCode.server, rawMessage: 'Rating failed'),
        ),
      );

      await cubit.submitRating(tripId: 100, comment: 'Great trip');

      expect(cubit.state.isSuccess, isFalse);
      expect(cubit.state.errorMessage?.rawMessage, 'Rating failed');
    });
  });
}
