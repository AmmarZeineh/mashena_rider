import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/utils/toast_helper.dart';
import 'package:mashena_rider/features/shared_trip/data/models/shared_ride_socket_events.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/shared_ride_room_details_entity.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/shared_trip_room_details_cubit/shared_trip_room_details_cubit.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/shared_trip_room_details_cubit/shared_trip_room_details_state.dart';
import 'package:mashena_rider/features/shared_trip/presentation/widgets/room_details/room_details_bottom_bar.dart';
import 'package:mashena_rider/features/shared_trip/presentation/widgets/room_details/room_details_driver_section.dart';
import 'package:mashena_rider/features/shared_trip/presentation/widgets/room_details/room_details_fare_section.dart';
import 'package:mashena_rider/features/shared_trip/presentation/widgets/room_details/room_details_map_section.dart';
import 'package:mashena_rider/features/shared_trip/presentation/widgets/room_details/room_details_notes_section.dart';
import 'package:mashena_rider/features/shared_trip/presentation/widgets/room_details/room_details_route_section.dart';
import 'package:mashena_rider/features/shared_trip/presentation/widgets/room_details/room_details_seats_section.dart';
import 'package:mashena_rider/features/shared_trip/presentation/widgets/room_details/seat_selection_bottom_sheet.dart';

class SharedTripRoomDetailsView extends StatelessWidget {
  final int roomId;

  const SharedTripRoomDetailsView({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<SharedTripRoomDetailsCubit>(param1: roomId)..fetchRoomDetails(),
      child: const _SharedTripRoomDetailsScaffold(),
    );
  }
}

class _SharedTripRoomDetailsScaffold extends StatefulWidget {
  const _SharedTripRoomDetailsScaffold();

  @override
  State<_SharedTripRoomDetailsScaffold> createState() =>
      _SharedTripRoomDetailsScaffoldState();
}

class _SharedTripRoomDetailsScaffoldState
    extends State<_SharedTripRoomDetailsScaffold> {
  String? _lastReportedStatus;
  String? _lastLiveNotice;
  String? _lastActionError;
  bool _wasJoined = false;
  bool _hasShownDropOff = false;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<SharedTripRoomDetailsCubit, SharedTripRoomDetailsState>(
      listener: (context, state) {
        if (state is SharedTripRoomDetailsSuccess) {
          // 1. Action error notification (distinct only)
          if (state.actionError != null &&
              state.actionError != _lastActionError) {
            _lastActionError = state.actionError;
            context.showErrorToast(state.actionError!);
          } else if (state.actionError == null) {
            _lastActionError = null;
          }

          // 2. Join room success toast (transition from null to non-null joinedPassenger)
          if (!_wasJoined && state.joinedPassenger != null) {
            _wasJoined = true;
            context.showSuccessToast(s.sharedTripJoinSuccess);
          } else if (state.joinedPassenger == null) {
            _wasJoined = false;
          }

          // 3. Status transition toast (only once per status change)
          final currentStatus = state.details.status.toUpperCase();
          if (_lastReportedStatus == null) {
            _lastReportedStatus = currentStatus;
          } else if (_lastReportedStatus != currentStatus) {
            _lastReportedStatus = currentStatus;
            if (state.details.isCanceled) {
              context.showErrorToast(
                state.details.cancellationReason != null &&
                        state.details.cancellationReason!.isNotEmpty
                    ? 'Trip Canceled: ${state.details.cancellationReason}'
                    : 'The ride has been canceled.',
              );
            } else if (state.details.isInProgress) {
              context.showInfoToast('Trip has started! Tracking live route.');
            } else if (state.details.isCompleted) {
              context.showSuccessToast('Trip completed! Thank you for riding.');
            }
          }

          // 4. Distinct live notice notification
          if (state.liveNotice != null && state.liveNotice != _lastLiveNotice) {
            _lastLiveNotice = state.liveNotice;
            context.showInfoToast(state.liveNotice!);
          }

          // 5. Rider removed by driver
          if (state.isCurrentRiderRemoved) {
            _showRemovedDialog(context, state.removalReason);
          }

          // 6. Rider dropped off summary & receipt modal (trigger once)
          if (state.currentUserDroppedOffPayload != null && !_hasShownDropOff) {
            _hasShownDropOff = true;
            _showDroppedOffBottomSheet(
              context,
              state.currentUserDroppedOffPayload!,
              state.details,
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            s.sharedTripRoomDetailsTitle,
            style: AppTextStyles.w600_18.copyWith(color: colorScheme.onSurface),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body:
            BlocBuilder<SharedTripRoomDetailsCubit, SharedTripRoomDetailsState>(
              builder: (context, state) {
                if (state is SharedTripRoomDetailsLoading ||
                    state is SharedTripRoomDetailsInitial) {
                  return _buildLoadingState(context);
                }

                if (state is SharedTripRoomDetailsError) {
                  return _buildErrorState(context, state.message);
                }

                if (state is SharedTripRoomDetailsSuccess) {
                  return _buildContent(context, state);
                }

                return const SizedBox.shrink();
              },
            ),
        bottomNavigationBar:
            BlocBuilder<SharedTripRoomDetailsCubit, SharedTripRoomDetailsState>(
              builder: (context, state) {
                if (state is SharedTripRoomDetailsSuccess) {
                  return state.joinedPassenger == null
                      ? RoomDetailsBottomBar(
                          details: state.details,
                          onJoinPressed: state.isJoining
                              ? null
                              : () => _onJoinTapped(context, state.details),
                        )
                      : const SizedBox.shrink();
                }
                return const SizedBox.shrink();
              },
            ),
      ),
    );
  }

  void _onJoinTapped(
    BuildContext context,
    SharedRideRoomDetailsEntity details,
  ) {
    SeatSelectionBottomSheet.show(
      context: context,
      details: details,
      onConfirm: (seatsNeeded) {
        context.read<SharedTripRoomDetailsCubit>().joinRoom(
          seatsNeeded: seatsNeeded,
        );
      },
    );
  }

  void _showRemovedDialog(BuildContext context, String? reason) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.errorColor),
              SizedBox(width: 8),
              Text('Removed from Ride'),
            ],
          ),
          content: Text(
            reason != null && reason.isNotEmpty
                ? 'You were removed from this shared ride by the driver.\n\nReason: $reason'
                : 'You were removed from this shared ride by the driver.',
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.go(AppRoutes.homePath);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showDroppedOffBottomSheet(
    BuildContext context,
    SharedRidePassengerDroppedPayload payload,
    SharedRideRoomDetailsEntity details,
  ) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final sheetBg = isDark ? colorScheme.surfaceContainerLow : Colors.white;
    final cardBg = isDark
        ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.6)
        : Colors.grey.shade50;
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.3)
        : AppColors.borderColor;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: sheetBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (sheetContext) {
        final fareValue = payload.finalFare ?? details.effectiveSeatFare;

        return PopScope(
          onPopInvokedWithResult: (didPop, _) {
            if (didPop && context.mounted) {
              context.go(AppRoutes.homePath);
            }
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 32.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: isDark
                          ? colorScheme.outlineVariant
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: AppColors.shieldGreen.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.shieldGreen,
                        size: 28.r,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.sharedTripArrivedTitle,
                            style: AppTextStyles.w700_18.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            s.sharedTripArrivedSubtitle,
                            style: AppTextStyles.w400_12.copyWith(
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            s.sharedTripFinalFare,
                            style: AppTextStyles.w500_14.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            '${fareValue.toStringAsFixed(0)} ${s.currencySyp}',
                            style: AppTextStyles.w700_18.copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      if (payload.finalDistanceKm != null ||
                          payload.finalDurationSec != null) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Divider(
                            height: 1,
                            thickness: 0.5,
                            color: borderColor,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (payload.finalDistanceKm != null)
                              Row(
                                children: [
                                  Icon(
                                    Icons.route_rounded,
                                    size: 14.r,
                                    color: AppColors.textGrey,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '${payload.finalDistanceKm!.toStringAsFixed(1)} km',
                                    style: AppTextStyles.w500_12.copyWith(
                                      color: AppColors.textGrey,
                                    ),
                                  ),
                                ],
                              ),
                            if (payload.finalDurationSec != null)
                              Row(
                                children: [
                                  Icon(
                                    Icons.timer_outlined,
                                    size: 14.r,
                                    color: AppColors.textGrey,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '${(payload.finalDurationSec! / 60).round()} min',
                                    style: AppTextStyles.w500_12.copyWith(
                                      color: AppColors.textGrey,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                FilledButton(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    context.go(AppRoutes.homePath);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    s.sharedTripBackToHome,
                    style: AppTextStyles.w600_14.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(BuildContext context, String error) {
    final s = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
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
              style: AppTextStyles.w500_14.copyWith(color: colorScheme.error),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            FilledButton.icon(
              onPressed: () =>
                  context.read<SharedTripRoomDetailsCubit>().fetchRoomDetails(),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(s.commonRetry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    SharedTripRoomDetailsSuccess state,
  ) {
    final details = state.details;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Interactive Map with Route, Pins & Live Driver Marker
          RoomDetailsMapSection(
            details: details,
            driverLocation: state.driverLocation,
          ),
          SizedBox(height: 14.h),

          // 2. Route Timeline & Summary
          RoomDetailsRouteSection(details: details),
          SizedBox(height: 14.h),

          // 3. Seat Occupancy & Passenger Visualizer with Presence
          RoomDetailsSeatsSection(
            details: details,
            onlineUserIds: state.onlineUserIds,
          ),
          SizedBox(height: 14.h),

          // 4. Driver & Vehicle Information with Presence
          RoomDetailsDriverSection(
            details: details,
            isDriverOnline: state.isDriverCurrentlyOnline,
          ),
          SizedBox(height: 14.h),

          // 5. Fare Breakdown
          RoomDetailsFareSection(details: details),

          // 6. Driver Notes (if available)
          if (details.notes != null && details.notes!.trim().isNotEmpty) ...[
            SizedBox(height: 14.h),
            RoomDetailsNotesSection(notes: details.notes),
          ],
        ],
      ),
    );
  }
}
