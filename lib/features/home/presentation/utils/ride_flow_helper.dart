import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_marker.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_polyline.dart';
import 'package:mashena_rider/core/services/osrm_route_service.dart';
import 'package:mashena_rider/features/home/presentation/cubits/home_location_cubit/home_location_cubit.dart';
import 'package:mashena_rider/features/home/presentation/models/confirmed_ride_flow_result.dart';

import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/utils/app_toast.dart';

abstract class RideFlowHelper {
  /// Opens the address picker and handles the confirmed ride result.
  static Future<void> openPickAddressAndDrawRoute(
    BuildContext context, {
    ConfirmedRideFlowResult? initialResult,
  }) async {
    final result = await context.push<ConfirmedRideFlowResult?>(
      AppRoutes.pickAdressPath,
      extra: initialResult,
    );

    if (!context.mounted || result == null) return;

    final homeCubit = context.read<HomeCubit>();

    // Start loading state
    homeCubit.setFetchingRoute(true);

    try {
      // 1. Determine Route Points (prefer backend polyline, fallback to OSRM)
      List<MapLatLng> routePoints = [];
      final backendPolyline = result.estimateResponse.polyline;

      if (backendPolyline != null && backendPolyline.isNotEmpty) {
        try {
          final decoded = decodePolyline(backendPolyline);
          routePoints = decoded.map((coord) {
            return MapLatLng(
              latitude: coord[0].toDouble(),
              longitude: coord[1].toDouble(),
            );
          }).toList();
        } catch (_) {
          // Fallback if decode fails
        }
      }

      if (routePoints.isEmpty) {
        final routeService = getIt<OSRMRouteService>();
        routePoints = await routeService.getRoute([
          result.pickup,
          ...result.estimateResponse.stops,
          result.destination,
        ]);
      }

      // Check if cubit is still open and context is mounted before emitting
      if (!homeCubit.isClosed && context.mounted) {
        // 2. Set Polylines
        if (routePoints.isNotEmpty) {
          homeCubit.setPolylines([
            MapPolyline(
              id: 'ride_route_border',
              points: routePoints,
              color: AppColors.primaryColor.withValues(alpha: 0.2),
              width: 14,
            ),
            MapPolyline(
              id: 'ride_route',
              points: routePoints,
              color: AppColors.primaryColor,
              width: 7,
            ),
          ]);
        }

        // 3. Set Markers (Pickup + Stops + Destination)
        final markers = <MapMarker>[
          MapMarker(
            id: 'pickup',
            position: result.pickup,
            iconWidget: PointMarker(
              color: const Color(0xFF34A853),
              icon: Icons.trip_origin,
              label: S.of(context).homeCurrentLocation,
            ),
          ),
        ];

        // Add Stop Markers
        for (int i = 0; i < result.estimateResponse.stops.length; i++) {
          markers.add(
            MapMarker(
              id: 'stop_$i',
              position: result.estimateResponse.stops[i],
              iconWidget: const PointMarker(
                color: Colors.orange,
                icon: Icons.stop_circle_outlined,
              ),
            ),
          );
        }

        // Add Destination Marker
        markers.add(
          MapMarker(
            id: 'destination',
            position: result.destination,
            iconWidget: const PointMarker(
              color: Colors.red,
              icon: Icons.location_on,
            ),
          ),
        );

        homeCubit.setMarkers(markers);
        homeCubit.setConfirmedRide(result);
      }
    } catch (e) {
      // Handle or log error
    } finally {
      if (!homeCubit.isClosed) {
        homeCubit.setFetchingRoute(false);

        // Show a helpful message if route drawing failed but we have results
        if (context.mounted &&
            homeCubit.state.polylines.isEmpty &&
            homeCubit.state.confirmedRideResult != null) {
          AppToast.show(
            context,
            message: S.of(context).homeMapRouteUnavailable,
            type: AppToastType.warning,
          );
        }
      }
    }
  }

  /// Draws an amber driver→pickup route on the map when the ride is confirmed.
  ///
  /// Since real-time driver tracking is not yet available, a simulated driver
  /// position is placed approximately 0.4 km north of the pickup point.
  static void drawDriverRoute(BuildContext context, MapLatLng pickupLatLng) {
    final homeCubit = context.read<HomeCubit>();

    // Simulated driver location: ~0.004 degrees north of pickup (~444 m).
    final driverLatLng = MapLatLng(
      latitude: pickupLatLng.latitude + 0.004,
      longitude: pickupLatLng.longitude + 0.001,
    );

    // Append the driver→pickup polyline (amber, thinner).
    final updatedPolylines = List<MapPolyline>.from(homeCubit.state.polylines)
      ..add(
        MapPolyline(
          id: 'driver_to_pickup_border',
          points: [driverLatLng, pickupLatLng],
          color: Colors.amber.withValues(alpha: 0.3),
          width: 10,
        ),
      )
      ..add(
        MapPolyline(
          id: 'driver_to_pickup',
          points: [driverLatLng, pickupLatLng],
          color: Colors.amber,
          width: 4,
        ),
      );
    homeCubit.setPolylines(updatedPolylines);

    // Append a car marker at the driver position.
    final updatedMarkers = List<MapMarker>.from(homeCubit.state.markers)
      ..add(
        MapMarker(
          id: 'driver',
          position: driverLatLng,
          iconWidget: _DriverMarker(),
        ),
      );
    homeCubit.setMarkers(updatedMarkers);
  }
}

/// A premium styled map point marker with glow effect.
class PointMarker extends StatelessWidget {
  const PointMarker({
    super.key,
    required this.color,
    required this.icon,
    this.label,
  });

  final Color color;
  final IconData icon;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow ring
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
            ),
            // Inner solid circle with border
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Animated car icon used to mark the driver position on the map.
class _DriverMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.18),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.amber,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withValues(alpha: 0.55),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.directions_car_filled_rounded,
            color: Colors.white,
            size: 16,
          ),
        ),
      ],
    );
  }
}
