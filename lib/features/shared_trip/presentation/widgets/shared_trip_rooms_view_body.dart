import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/features/pool/presentation/models/pool_discovery_args.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/shared_trip_rooms_cubit/shared_trip_rooms_cubit.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/shared_trip_rooms_cubit/shared_trip_rooms_state.dart';
import 'shared_ride_card.dart';
import 'shared_trip_locations_header.dart';

class SharedTripRoomsViewBody extends StatelessWidget {
  const SharedTripRoomsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SharedTripLocationsHeader(),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<SharedTripRoomsCubit, SharedTripRoomsState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return _buildLoadingState(context);
                }

                if (state.errorMessage != null) {
                  return _buildErrorState(context, state.errorMessage!);
                }

                if (state.rooms.isEmpty) {
                  return _buildEmptyState(context, state);
                }

                return _buildRoomsList(context, state);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            S.of(context).sharedTripSearchingRooms,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded, size: 48, color: colorScheme.error),
          const SizedBox(height: 12),
          Text(
            error,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => context.read<SharedTripRoomsCubit>().searchRooms(),
            icon: const Icon(Icons.refresh_rounded),
            label: Text(S.of(context).commonRetry),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, SharedTripRoomsState state) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.groups_2_outlined,
                size: 40,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              S.of(context).sharedTripNoRoomsFound,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {
                context.push(
                  AppRoutes.poolDiscoveryPath,
                  extra: PoolDiscoveryArgs(
                    pickup: state.pickupPlace,
                    destination: state.destinationPlace,
                  ),
                );
              },
              icon: const Icon(Icons.groups_3_rounded),
              label: const Text('Try Passenger Pool Instead'),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomsList(BuildContext context, SharedTripRoomsState state) {
    return ListView.builder(
      itemCount: state.rooms.length,
      itemBuilder: (context, index) {
        return SharedRideCard(room: state.rooms[index]);
      },
    );
  }
}
