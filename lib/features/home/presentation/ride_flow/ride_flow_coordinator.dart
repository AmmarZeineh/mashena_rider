import 'dart:math' show pi;
import 'package:mashena_rider/core/services/logger_service.dart';
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
import 'package:mashena_rider/features/home/presentation/shell/cubits/map_state_cubit/map_state_cubit.dart';
import 'package:mashena_rider/features/home/presentation/booking/cubits/ride_booking_cubit/ride_booking_cubit.dart';
import 'package:mashena_rider/features/home/presentation/common/models/confirmed_ride_flow_result.dart';

import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/utils/app_toast.dart';

abstract class RideFlowCoordinator {
  /// Opens the address picker and handles the confirmed ride result.
  static Future<void> openPickAddressAndDrawRoute(
    BuildContext context, {
    ConfirmedRideFlowResult? initialResult,
  }) async {
    return _openAddressAndDrawRoute(
      context,
      routePath: AppRoutes.pickAdressPath,
      initialResult: initialResult,
    );
  }

  /// Opens the shared trip address picker and handles the confirmed ride result.
  static Future<void> openSharedTripAddressAndDrawRoute(
    BuildContext context, {
    ConfirmedRideFlowResult? initialResult,
  }) async {
    return _openAddressAndDrawRoute(
      context,
      routePath: AppRoutes.sharedTripPickAddressPath,
      initialResult: initialResult,
    );
  }

  static Future<void> _openAddressAndDrawRoute(
    BuildContext context, {
    required String routePath,
    ConfirmedRideFlowResult? initialResult,
  }) async {
    final result = await context.push<ConfirmedRideFlowResult?>(
      routePath,
      extra: initialResult,
    );

    if (!context.mounted || result == null) return;

    final mapStateCubit = context.read<MapStateCubit>();
    final rideBookingCubit = context.read<RideBookingCubit>();

    // Start loading state
    mapStateCubit.setFetchingRoute(isFetching: true);

    try {
      // 1. Determine Route Points:
      //    Priority: backend routeGeometry.points > encoded polyline > OSRM
      List<MapLatLng> routePoints = [];

      final backendRoutePoints = result.estimateResponse.routePoints;
      if (backendRoutePoints.isNotEmpty) {
        routePoints = backendRoutePoints;
      }

      if (routePoints.isEmpty) {
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
      }

      if (routePoints.isEmpty) {
        final routeService = getIt<OSRMRouteService>();
        final details = await routeService.getRouteDetails([
          result.pickup,
          ...result.estimateResponse.stops,
          result.destination,
        ]);
        if (details != null) {
          routePoints = details.points;
        }
      }

      // Check if cubit is still open and context is mounted before emitting
      if (!mapStateCubit.isClosed && context.mounted) {
        // 2. Set Polylines
        if (routePoints.isNotEmpty) {
          mapStateCubit.setPolylines([
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

        mapStateCubit.setMarkers(markers);
        rideBookingCubit.setConfirmedRide(result);
      }
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to fetch/draw route in openPickAddressAndDrawRoute',
        name: 'features.home.ride_flow',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      if (!mapStateCubit.isClosed) {
        mapStateCubit.setFetchingRoute(isFetching: false);

        // Show a helpful message if route drawing failed but we have results
        if (context.mounted &&
            mapStateCubit.state.polylines.isEmpty &&
            rideBookingCubit.state.confirmedRideResult != null) {
          AppToast.show(
            context,
            message: S.of(context).homeMapRouteUnavailable,
            type: AppToastType.warning,
          );
        }
      }
    }
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
class DriverMarkerWidget extends StatelessWidget {
  const DriverMarkerWidget({super.key, this.bearing = 0.0});

  final double bearing;

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
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(end: bearing),
            duration: const Duration(milliseconds: 600),
            builder: (context, angle, child) {
              return Transform.rotate(
                angle: angle * pi / 180,
                child: const Icon(
                  Icons.directions_car_filled_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
