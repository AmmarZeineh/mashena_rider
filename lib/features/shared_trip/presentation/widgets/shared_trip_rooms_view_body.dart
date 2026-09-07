import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/utils/toast_helper.dart';
import 'package:mashena_rider/features/pool/presentation/models/pool_discovery_args.dart';
import 'package:mashena_rider/features/pool/presentation/widgets/pool_suggestion_card.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/shared_trip_rooms_cubit/shared_trip_rooms_cubit.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/shared_trip_rooms_cubit/shared_trip_rooms_state.dart';
import 'shared_ride_card.dart';
import 'shared_trip_locations_header.dart';
import 'unified_filter_tabs_bar.dart';

class SharedTripRoomsViewBody extends StatelessWidget {
  const SharedTripRoomsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final cubit = context.read<SharedTripRoomsCubit>();

    return BlocConsumer<SharedTripRoomsCubit, SharedTripRoomsState>(
      listener: (context, state) {
        if (state.errorMessage != null && state.hasAnyRooms) {
          context.showErrorToast(state.errorMessage!);
        }

        if (state.joinedPoolRoom != null) {
          context.showSuccessToast(s.poolJoinSuccess);
          context.pushReplacement(
            AppRoutes.poolLobbyPath,
            extra: state.joinedPoolRoom!.id,
          );
        }
      },
      builder: (context, state) {
        final items = state.displayedItems;

        return ModalProgressHUD(
          inAsyncCall: state.isJoiningPool,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SharedTripLocationsHeader(),
                SizedBox(height: 12.h),
                UnifiedFilterTabsBar(
                  activeFilter: state.activeFilter,
                  onFilterSelected: cubit.setFilter,
                  allCount: state.totalCount,
                  driverRidesCount: state.driverRidesCount,
                  poolLobbiesCount: state.poolLobbiesCount,
                ),
                SizedBox(height: 12.h),
                Expanded(child: _buildContent(context, state, items, cubit)),
                if (state.activeFilter == UnifiedRideFilter.poolLobbies &&
                    items.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  FilledButton.icon(
                    onPressed: () {
                      context.push(
                        AppRoutes.poolCreatePath,
                        extra: PoolDiscoveryArgs(
                          pickup: state.pickupPlace,
                          destination: state.destinationPlace,
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    label: Text(s.poolCreateNewLobby),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    SharedTripRoomsState state,
    List<UnifiedRideItem> items,
    SharedTripRoomsCubit cubit,
  ) {
    if (state.isLoading) {
      return _buildLoadingState(context);
    }

    if (state.errorMessage != null && !state.hasAnyRooms) {
      return _buildErrorState(context, state.errorMessage!);
    }

    if (items.isEmpty) {
      return _buildEmptyState(context, state);
    }

    return RefreshIndicator(
      onRefresh: cubit.searchRooms,
      child: _buildRoomsList(context, state, items, cubit),
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
          SizedBox(height: 16.h),
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
          Icon(
            Icons.error_outline_rounded,
            size: 48.r,
            color: colorScheme.error,
          ),
          SizedBox(height: 12.h),
          Text(
            error,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
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
    final s = S.of(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final (
      title,
      subtitle,
      icon,
      actionText,
      onAction,
    ) = switch (state.activeFilter) {
      UnifiedRideFilter.driverRides => (
        s.unifiedTripNoDriverRidesFound,
        s.unifiedTripCreatePoolCta,
        Icons.directions_car_outlined,
        s.unifiedTripPoolLobbies,
        () => context.read<SharedTripRoomsCubit>().setFilter(
          UnifiedRideFilter.poolLobbies,
        ),
      ),
      UnifiedRideFilter.poolLobbies => (
        s.unifiedTripNoPoolLobbiesFound,
        s.unifiedTripCreatePoolCta,
        Icons.groups_2_outlined,
        s.poolCreateNewLobby,
        () => context.push(
          AppRoutes.poolCreatePath,
          extra: PoolDiscoveryArgs(
            pickup: state.pickupPlace,
            destination: state.destinationPlace,
          ),
        ),
      ),
      UnifiedRideFilter.all => (
        s.unifiedTripNoRidesFound,
        s.unifiedTripCreatePoolCta,
        Icons.search_off_rounded,
        s.poolCreateNewLobby,
        () => context.push(
          AppRoutes.poolCreatePath,
          extra: PoolDiscoveryArgs(
            pickup: state.pickupPlace,
            destination: state.destinationPlace,
          ),
        ),
      ),
    };

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40.r, color: colorScheme.primary),
            ),
            SizedBox(height: 20.h),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            FilledButton.icon(
              onPressed: onAction,
              icon: Icon(
                state.activeFilter == UnifiedRideFilter.driverRides
                    ? Icons.groups_3_rounded
                    : Icons.add_rounded,
              ),
              label: Text(actionText),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomsList(
    BuildContext context,
    SharedTripRoomsState state,
    List<UnifiedRideItem> items,
    SharedTripRoomsCubit cubit,
  ) {
    final s = S.of(context);
    final showBadges = state.activeFilter == UnifiedRideFilter.all;

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return switch (item) {
          DriverRideItem(:final room) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showBadges)
                _buildTypeBadge(
                  context,
                  icon: Icons.directions_car_rounded,
                  label: s.unifiedTripDriverBadge,
                  color: AppColors.primaryColor,
                ),
              SharedRideCard(room: room),
            ],
          ),
          PoolLobbyItem(:final room) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showBadges)
                _buildTypeBadge(
                  context,
                  icon: Icons.groups_3_rounded,
                  label: s.unifiedTripPoolBadge,
                  color: AppColors.shieldGreen,
                ),
              PoolSuggestionCard(
                room: room,
                onJoin: () => cubit.joinPoolRoom(roomId: room.id),
              ),
            ],
          ),
        };
      },
    );
  }

  Widget _buildTypeBadge(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.r, color: color),
          SizedBox(width: 6.w),
          Text(label, style: AppTextStyles.w600_10.copyWith(color: color)),
        ],
      ),
    );
  }
}
