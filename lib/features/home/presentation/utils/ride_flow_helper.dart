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
      try {
        final routeService = getIt<OSRMRouteService>();
        routePoints = await routeService.getRoute([
          result.pickup,
          ...result.estimateResponse.stops,
          result.destination,
        ]);
      } catch (_) {
        // Route drawing is best-effort
      }
    }

    if (!context.mounted) return;

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
          iconWidget: PointMarker(
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

    if (!context.mounted) return;

    // Set state so HomeViewBody shows RideBookingOverlay
    // persistently in the Stack (non-modal = map stays interactive)
    homeCubit.setConfirmedRide(result);
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
