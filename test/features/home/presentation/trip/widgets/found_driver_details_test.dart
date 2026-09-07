import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/features/home/domain/entities/matched_trip.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/driver_tracking_cubit/driver_tracking_cubit.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/trip_lifecycle_cubit/trip_lifecycle_cubit.dart';
import 'package:mashena_rider/features/home/presentation/trip/widgets/ride_confirmed_sheet_components/found_driver_details.dart';

class MockTripLifecycleCubit extends Mock implements TripLifecycleCubit {}

class MockDriverTrackingCubit extends Mock implements DriverTrackingCubit {}

void main() {
  late MockTripLifecycleCubit mockTripLifecycleCubit;
  late MockDriverTrackingCubit mockDriverTrackingCubit;

  setUp(() {
    mockTripLifecycleCubit = MockTripLifecycleCubit();
    mockDriverTrackingCubit = MockDriverTrackingCubit();
  });

  Widget buildTestWidget() {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<TripLifecycleCubit>.value(
              value: mockTripLifecycleCubit,
            ),
            BlocProvider<DriverTrackingCubit>.value(
              value: mockDriverTrackingCubit,
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: S.localizationsDelegates,
            supportedLocales: S.supportedLocales,
            home: Scaffold(body: FoundDriverDetails()),
          ),
        );
      },
    );
  }

  testWidgets(
    'FoundDriverDetails does not render call or message buttons, renders share button',
    (tester) async {
      const matchedTrip = MatchedTrip(
        tripId: 100,
        tripStatus: 'assigned',
        rideRequestId: 25,
        pickupLat: 33.5138,
        pickupLng: 36.2765,
        destinationLat: 33.5200,
        destinationLng: 36.2800,
        driverId: 10,
        driverFullName: 'Ahmad Driver',
        driverRatingAvg: 4.9,
        stops: [],
        model: 'Corolla',
        color: 'White',
        plateNumber: '123456',
      );

      when(() => mockTripLifecycleCubit.state).thenReturn(
        const TripLifecycleState(
          isDriverFound: true,
          isLoadingMatchedTrip: false,
          matchedTrip: matchedTrip,
        ),
      );
      when(
        () => mockTripLifecycleCubit.stream,
      ).thenAnswer((_) => const Stream.empty());

      when(
        () => mockDriverTrackingCubit.state,
      ).thenReturn(const DriverTrackingState());
      when(
        () => mockDriverTrackingCubit.stream,
      ).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Verify driver info is displayed
      expect(find.text('Ahmad Driver'), findsOneWidget);

      // Verify message and call buttons are removed
      expect(find.byIcon(Icons.chat_bubble_outline_rounded), findsNothing);
      expect(find.byIcon(Icons.phone_rounded), findsNothing);

      // Verify share button is present
      expect(find.byIcon(Icons.share_rounded), findsOneWidget);
    },
  );
}
