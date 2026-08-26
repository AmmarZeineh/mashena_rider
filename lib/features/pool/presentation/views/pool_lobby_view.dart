import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/utils/toast_helper.dart';
import '../cubits/pool_lobby_cubit/pool_lobby_cubit.dart';
import '../cubits/pool_lobby_cubit/pool_lobby_state.dart';
import '../widgets/pool_lobby_map.dart';
import '../widgets/pool_meeting_point_card.dart';
import '../widgets/pool_member_avatar_group.dart';
import '../widgets/pool_status_badge.dart';

class PoolLobbyView extends StatelessWidget {
  final int roomId;

  const PoolLobbyView({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PoolLobbyCubit>(param1: roomId),
      child: const _PoolLobbyScaffold(),
    );
  }
}

class _PoolLobbyScaffold extends StatefulWidget {
  const _PoolLobbyScaffold();

  @override
  State<_PoolLobbyScaffold> createState() => _PoolLobbyScaffoldState();
}

class _PoolLobbyScaffoldState extends State<_PoolLobbyScaffold> {
  String? _lastToast;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PoolLobbyCubit, PoolLobbyState>(
      listener: (context, state) {
        // 1. Toast notifications
        if (state.toastMessage != null && state.toastMessage != _lastToast) {
          _lastToast = state.toastMessage;
          context.showInfoToast(state.toastMessage!);
        }

        // 2. Error handling
        if (state.errorMessage != null) {
          context.showErrorToast(state.errorMessage!);
        }

        // 3. Matched Driver Handoff -> Switch to Active Shared Ride
        if (state.matchedSharedRideId != null) {
          context.showSuccessToast('Driver Found! Starting your ride.');
          context.pushReplacement(
            AppRoutes.sharedTripRoomDetailsPath,
            extra: state.matchedSharedRideId,
          );
        }

        // 4. Left or Cancelled
        if (state.hasLeftOrCancelled) {
          context.go(AppRoutes.homePath);
        }

        // 5. Expired Modal
        if (state.isExpired) {
          _showNoticeDialog(
            context,
            title: 'Pool Room Expired',
            message:
                'No driver was matched before the departure time. The room has expired.',
          );
        }

        // 6. Cancelled by Creator Modal
        if (state.isCancelled && !state.isCreator) {
          _showNoticeDialog(
            context,
            title: 'Pool Room Cancelled',
            message: 'The host has cancelled this pool room.',
          );
        }

        // 7. Removed Modal
        if (state.isRemoved) {
          _showNoticeDialog(
            context,
            title: 'Removed from Room',
            message: 'You were removed from this pool room.',
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<PoolLobbyCubit>();

        return Scaffold(
          appBar: AppBar(
            title: Text('Pool Lobby #${cubit.roomId}'),
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => context.go(AppRoutes.homePath),
            ),
          ),
          body: ModalProgressHUD(
            inAsyncCall: state.isLeaving || state.isCancelling,
            child: state.isLoading || state.room == null
                ? const Center(child: CircularProgressIndicator())
                : _buildLobbyContent(context, state, cubit),
          ),
        );
      },
    );
  }

  Widget _buildLobbyContent(
    BuildContext context,
    PoolLobbyState state,
    PoolLobbyCubit cubit,
  ) {
    final room = state.room!;

    return Stack(
      children: [
        // 1. Map View (Top portion - responsive)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.5,
          child: PoolLobbyMap(
            room: room,
            currentUserId: state.currentUserId,
            walkingRoutePoints: state.walkingRoutePoints,
          ),
        ),

        // 2. Floating Status Badge
        Positioned(
          top: 16.h,
          left: 16.w,
          right: 16.w,
          child: Center(
            child: PoolStatusBadge(
              status: room.status,
              currentPassengers: room.currentPassengers,
              maxPassengers: room.maxPassengers,
            ),
          ),
        ),

        // 3. Draggable / Bottom Content Sheet
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.50,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 18,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: ListView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              children: [
                // Departure Time chip
                if (room.departureTime != null)
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: AppColors.primaryColor,
                            size: 14.r,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Departure: ${DateFormat('h:mm a').format(room.departureTime!.toLocal())}',
                            style: AppTextStyles.w600_12.copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Meeting point info card
                PoolMeetingPointCard(
                  address: room.meetingAddress,
                  walkingDistanceMeters: state.walkingDistanceMeters,
                  walkingDurationSeconds: state.walkingDurationSeconds,
                ),
                SizedBox(height: 14.h),

                // Passenger roster
                PoolMemberAvatarGroup(
                  room: room,
                  currentUserId: state.currentUserId,
                ),
                SizedBox(height: 20.h),

                // Cancel or Leave buttons
                _buildActionButtons(context, state, cubit),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    PoolLobbyState state,
    PoolLobbyCubit cubit,
  ) {
    final s = S.of(context);
    final room = state.room;
    if (room == null) return const SizedBox.shrink();

    // Show leave / cancel when room is open or ready for driver
    final canAct = room.status.isOpen || room.status.isReadyForDriver;
    if (!canAct) return const SizedBox.shrink();

    if (state.isCreator) {
      return OutlinedButton.icon(
        onPressed: () => _confirmCancelRoom(context, cubit),
        icon: const Icon(Icons.cancel_outlined),
        label: Text(s.poolCancelRoom),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.errorColor,
          side: const BorderSide(color: AppColors.errorColor),
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      );
    } else {
      return OutlinedButton.icon(
        onPressed: () => _confirmLeaveRoom(context, cubit),
        icon: const Icon(Icons.exit_to_app_rounded),
        label: Text(s.poolLeaveRoom),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.errorColor,
          side: const BorderSide(color: AppColors.errorColor),
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      );
    }
  }

  void _confirmCancelRoom(BuildContext context, PoolLobbyCubit cubit) {
    final s = S.of(context);
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(s.poolCancelConfirmTitle),
        content: Text(s.poolCancelConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(s.commonCancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              cubit.cancelRoom();
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.errorColor,
            ),
            child: Text(s.poolCancelRoom),
          ),
        ],
      ),
    );
  }

  void _confirmLeaveRoom(BuildContext context, PoolLobbyCubit cubit) {
    final s = S.of(context);
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(s.poolLeaveConfirmTitle),
        content: Text(s.poolLeaveConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(s.commonCancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              cubit.leaveRoom();
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.errorColor,
            ),
            child: Text(s.poolLeaveRoom),
          ),
        ],
      ),
    );
  }

  void _showNoticeDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    final s = S.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              context.go(AppRoutes.homePath);
            },
            child: Text(s.commonOk),
          ),
        ],
      ),
    );
  }
}
