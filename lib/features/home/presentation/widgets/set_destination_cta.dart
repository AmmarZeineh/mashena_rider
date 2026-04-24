import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_marker.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_polyline.dart';
import 'package:mashena_rider/core/services/osrm_route_service.dart';
import 'package:mashena_rider/features/home/presentation/cubits/home_location_cubit/home_location_cubit.dart';
import 'package:mashena_rider/features/home/presentation/models/confirmed_ride_flow_result.dart';

/// Entry CTA for the address picker flow.
///
/// This replaces the old draggable "where to" sheet.
class SetDestinationCta extends StatelessWidget {
  const SetDestinationCta({super.key});

  Future<void> _openPickAddress(BuildContext context) async {
    final result = await context.push<ConfirmedRideFlowResult?>(
      AppRoutes.pickAdressPath,
    );
    if (!context.mounted || result == null) return;

    final routeService = getIt<OSRMRouteService>();
    final homeCubit = context.read<HomeCubit>();

    // Fetch & draw route polyline (acts as backend route).
    try {
      final route = await routeService.getRoute(
        result.pickup,
        result.destination,
      );
      if (!context.mounted) return;
      if (route.isNotEmpty) {
        final colorScheme = Theme.of(context).colorScheme;

        // Two-layer polyline: translucent border + solid route
        homeCubit.setPolylines([
          MapPolyline(
            id: 'ride_route_border',
            points: route,
            color: colorScheme.primary.withValues(alpha: 0.25),
            width: 14,
          ),
          MapPolyline(
            id: 'ride_route',
            points: route,
            color: colorScheme.primary,
            width: 6,
          ),
        ]);

        // Styled markers for pickup and destination
        homeCubit.setMarkers([
          MapMarker(
            id: 'pickup',
            position: result.pickup,
            iconWidget: _PointMarker(
              color: const Color(0xFF34A853),
              icon: Icons.trip_origin,
              label: S.of(context).homeCurrentLocation,
            ),
          ),
          MapMarker(
            id: 'destination',
            position: result.destination,
            iconWidget: _PointMarker(
              color: colorScheme.error,
              icon: Icons.location_on,
            ),
          ),
        ]);
      }
    } catch (_) {
      // Route drawing is best-effort; estimates still show.
    }

    if (!context.mounted) return;

    // Set state so HomeViewBody shows CarTypeBottomSheet
    // persistently in the Stack (non-modal = map stays interactive)
    homeCubit.setConfirmedRide(result);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(22),
          color: colorScheme.surface,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () => _openPickAddress(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary
                              .withValues(alpha: 0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.local_taxi_rounded,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          S.of(context).rideRequestRide,
                          style: textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          S.of(context).homeWhereTo,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyMedium
                              ?.copyWith(
                                color:
                                    colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A premium styled map point marker with glow effect.
class _PointMarker extends StatelessWidget {
  const _PointMarker({
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
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
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
