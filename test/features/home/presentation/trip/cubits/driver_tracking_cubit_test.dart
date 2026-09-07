import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/services/osrm_route_service.dart';
import 'package:mashena_rider/features/home/domain/repositories/ride_repository.dart';
import 'package:mashena_rider/features/home/presentation/shell/cubits/map_state_cubit/map_state_cubit.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/driver_tracking_cubit/driver_tracking_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockRideRepository extends Mock implements RideRepository {}

class MockOSRMRouteService extends Mock implements OSRMRouteService {}

void main() {
  late MockRideRepository mockRideRepo;
  late MockOSRMRouteService mockOsrm;
  late MapStateCubit mapStateCubit;
  late DriverTrackingCubit driverTrackingCubit;
  late StreamController<MapLatLng> locationController;

  const testPickup = MapLatLng(latitude: 33.5138, longitude: 36.2765);
  const testDest = MapLatLng(latitude: 33.5200, longitude: 36.2800);

  setUp(() {
    mockRideRepo = MockRideRepository();
    mockOsrm = MockOSRMRouteService();
    locationController = StreamController<MapLatLng>.broadcast();

    when(
      () => mockRideRepo.driverLocationStream,
    ).thenAnswer((_) => locationController.stream);

    mapStateCubit = MapStateCubit();
    driverTrackingCubit = DriverTrackingCubit(
      mockRideRepo,
      mockOsrm,
      mapStateCubit,
    );
  });

  tearDown(() {
    locationController.close();
    driverTrackingCubit.close();
    mapStateCubit.close();
  });

  test(
    'startTracking sets pickup & destination and clears driver polylines',
    () {
      driverTrackingCubit.startTracking(
        pickup: testPickup,
        destination: testDest,
      );

      expect(driverTrackingCubit.state.isTracking, isTrue);
      expect(driverTrackingCubit.state.pickup, testPickup);
      expect(driverTrackingCubit.state.destination, testDest);
      expect(mapStateCubit.state.polylines, isEmpty);
    },
  );

  test(
    'receiving driver location updates driver marker but DOES NOT add driver polylines',
    () async {
      when(() => mockOsrm.getRouteDetails(any())).thenAnswer(
        (_) async => const OSRMRouteDetails(
          distance: 1200,
          duration: 180,
          points: [
            MapLatLng(latitude: 33.5100, longitude: 36.2700),
            testPickup,
          ],
        ),
      );

      driverTrackingCubit.startTracking(
        pickup: testPickup,
        destination: testDest,
      );

      const driverPos = MapLatLng(latitude: 33.5100, longitude: 36.2700);
      locationController.add(driverPos);

      // Marker is updated immediately
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(mapStateCubit.state.markers.any((m) => m.id == 'driver'), isTrue);
      final driverMarker = mapStateCubit.state.markers.firstWhere(
        (m) => m.id == 'driver',
      );
      expect(driverMarker.position, driverPos);

      // No polylines drawn on map
      expect(mapStateCubit.state.polylines, isEmpty);

      // Wait for debounced OSRM calculation for ETA
      await Future<void>.delayed(const Duration(milliseconds: 350));
      expect(driverTrackingCubit.state.driverEta, '3 min');
      expect(driverTrackingCubit.state.driverDistance, '1.2 km');

      // Still NO driver polylines on map
      expect(
        mapStateCubit.state.polylines.any((p) => p.id.startsWith('driver_')),
        isFalse,
      );
    },
  );

  test(
    'onTripStarted sets isTripStarted to true and keeps polylines clean',
    () {
      driverTrackingCubit.startTracking(
        pickup: testPickup,
        destination: testDest,
      );

      expect(driverTrackingCubit.state.isTripStarted, isFalse);

      const newDest = MapLatLng(latitude: 33.5300, longitude: 36.2900);
      driverTrackingCubit.onTripStarted(destination: newDest);

      expect(driverTrackingCubit.state.isTripStarted, isTrue);
      expect(driverTrackingCubit.state.destination, newDest);
      expect(
        mapStateCubit.state.polylines.any((p) => p.id.startsWith('driver_')),
        isFalse,
      );
    },
  );

  test('stopTracking clears marker, driver polylines, and resets state', () {
    driverTrackingCubit.startTracking(
      pickup: testPickup,
      destination: testDest,
    );

    const driverPos = MapLatLng(latitude: 33.5100, longitude: 36.2700);
    locationController.add(driverPos);

    driverTrackingCubit.stopTracking();

    expect(mapStateCubit.state.markers.any((m) => m.id == 'driver'), isFalse);
    expect(driverTrackingCubit.state.isTracking, isFalse);
    expect(mapStateCubit.state.polylines, isEmpty);
  });

  test(
    'startTracking clears stale driver state and stale driver marker from previous ride',
    () async {
      when(() => mockOsrm.getRouteDetails(any())).thenAnswer(
        (_) async => const OSRMRouteDetails(
          distance: 500,
          duration: 60,
          points: [
            MapLatLng(latitude: 33.5100, longitude: 36.2700),
            testPickup,
          ],
        ),
      );

      // Simulate a previous tracking session
      driverTrackingCubit.startTracking(
        pickup: testPickup,
        destination: testDest,
      );
      locationController.add(
        const MapLatLng(latitude: 33.5100, longitude: 36.2700),
      );
      await Future<void>.delayed(const Duration(milliseconds: 350));
      expect(mapStateCubit.state.markers.any((m) => m.id == 'driver'), isTrue);
      expect(driverTrackingCubit.state.driverLocation, isNotNull);

      // Start a new tracking session
      const newPickup = MapLatLng(latitude: 33.5500, longitude: 36.3000);
      const newDest = MapLatLng(latitude: 33.5600, longitude: 36.3100);
      driverTrackingCubit.startTracking(
        pickup: newPickup,
        destination: newDest,
      );

      // Stale driver state and marker must be completely cleared
      expect(mapStateCubit.state.markers.any((m) => m.id == 'driver'), isFalse);
      expect(driverTrackingCubit.state.driverLocation, isNull);
      expect(driverTrackingCubit.state.driverBearing, 0.0);
      expect(driverTrackingCubit.state.driverDistance, isNull);
      expect(driverTrackingCubit.state.driverEta, isNull);
      expect(driverTrackingCubit.state.isDriverArrived, isFalse);
      expect(driverTrackingCubit.state.isTripStarted, isFalse);
      expect(driverTrackingCubit.state.pickup, newPickup);
      expect(driverTrackingCubit.state.destination, newDest);
    },
  );
}
