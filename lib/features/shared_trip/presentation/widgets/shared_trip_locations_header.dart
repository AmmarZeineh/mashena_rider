import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/shared_trip_rooms_cubit/shared_trip_rooms_cubit.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/shared_trip_rooms_cubit/shared_trip_rooms_state.dart';
import 'package:mashena_rider/features/shared_trip/presentation/models/shared_trip_rooms_args.dart';
import 'shared_trip_location_point_row.dart';

class SharedTripLocationsHeader extends StatelessWidget {
  const SharedTripLocationsHeader({super.key});

  Future<void> _onChangeLocations(BuildContext context) async {
    final cubit = context.read<SharedTripRoomsCubit>();
    final currentPickup = cubit.state.pickupPlace;
    final currentDest = cubit.state.destinationPlace;

    final result = await context.push<SharedTripRoomsArgs?>(
      AppRoutes.sharedTripPickAddressPath,
      extra: SharedTripRoomsArgs(
        pickup: currentPickup,
        destination: currentDest,
      ),
    );

    if (result != null) {
      cubit.updateLocations(
        pickup: result.pickup,
        destination: result.destination,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return BlocBuilder<SharedTripRoomsCubit, SharedTripRoomsState>(
      builder: (context, state) {
        final cubit = context.read<SharedTripRoomsCubit>();

        return Material(
          elevation: isDark ? 0 : 6,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          color: isDark ? colorScheme.surfaceContainerLow : colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Locations Visual Indicators & Names
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SharedTripLocationPointRow(
                        iconColor: AppColors.shieldGreen,
                        icon: Icons.trip_origin_rounded,
                        label: S.of(context).sharedTripPickup,
                        placeName: state.pickupPlace.name,
                        textTheme: textTheme,
                        colorScheme: colorScheme,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            Container(
                              width: 2,
                              height: 16,
                              color: colorScheme.outlineVariant.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Divider(
                                height: 1,
                                thickness: 0.5,
                                color: colorScheme.outlineVariant.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SharedTripLocationPointRow(
                        iconColor: colorScheme.error,
                        icon: Icons.location_on_rounded,
                        label: S.of(context).sharedTripDestination,
                        placeName: state.destinationPlace.name,
                        textTheme: textTheme,
                        colorScheme: colorScheme,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // 2. Action Buttons (Change + Search)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ActionButton(
                      icon: Icons.edit_location_alt_rounded,
                      tooltip: S.of(context).sharedTripChangeLocations,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      foregroundColor: colorScheme.onSurfaceVariant,
                      onPressed: () => _onChangeLocations(context),
                    ),
                    const SizedBox(height: 10),
                    _ActionButton(
                      icon: Icons.search_rounded,
                      tooltip: S.of(context).sharedTripSearchRooms,
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      onPressed: cubit.searchRooms,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onPressed,
        child: Tooltip(
          message: tooltip,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(icon, size: 20, color: foregroundColor),
          ),
        ),
      ),
    );
  }
}
