import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/utils/toast_helper.dart';
import '../cubits/pool_create_cubit/pool_create_cubit.dart';
import '../cubits/pool_create_cubit/pool_create_state.dart';
import '../models/pool_discovery_args.dart';

class PoolCreateView extends StatelessWidget {
  final PoolDiscoveryArgs args;

  const PoolCreateView({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PoolCreateCubit>(param1: args),
      child: const _PoolCreateViewBody(),
    );
  }
}

class _PoolCreateViewBody extends StatelessWidget {
  const _PoolCreateViewBody();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? Theme.of(context).colorScheme.surfaceContainerHigh
        : Colors.white;
    final borderColor = isDark ? Colors.white12 : AppColors.borderColor;

    return BlocConsumer<PoolCreateCubit, PoolCreateState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          context.showErrorToast(state.errorMessage!);
        }

        if (state.createdRoom != null) {
          context.showSuccessToast('Pool room created! Waiting in lobby.');
          context.pushReplacement(
            AppRoutes.poolLobbyPath,
            extra: state.createdRoom!.id,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<PoolCreateCubit>();
        final args = cubit.args;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Pool Room'),
            centerTitle: true,
            elevation: 0,
          ),
          body: ModalProgressHUD(
            inAsyncCall: state.isSubmitting,
            child: SafeArea(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                children: [
                  // Route info
                  _buildRouteCard(context, args, cardBg, borderColor),
                  SizedBox(height: 20.h),

                  // Departure Time Card
                  _buildDepartureTimeCard(
                    context,
                    state,
                    cubit,
                    cardBg,
                    borderColor,
                  ),
                  SizedBox(height: 16.h),

                  // Creator Seats Needed
                  _buildSeatsNeededCard(
                    context,
                    state,
                    cubit,
                    cardBg,
                    borderColor,
                  ),
                  SizedBox(height: 32.h),

                  // Submit Button
                  FilledButton.icon(
                    onPressed: state.isSubmitting
                        ? null
                        : () => cubit.submitCreatePool(),
                    icon: const Icon(Icons.rocket_launch_rounded),
                    label: const Text('Publish Pool Lobby'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRouteCard(
    BuildContext context,
    PoolDiscoveryArgs args,
    Color cardBg,
    Color borderColor,
  ) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Pool Journey',
            style: AppTextStyles.w700_14.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Icons.trip_origin_rounded,
                color: AppColors.shieldGreen,
                size: 18.r,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  args.pickup.name,
                  style: AppTextStyles.w500_14.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            child: const Divider(height: 1),
          ),
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: AppColors.errorColor,
                size: 18.r,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  args.destination.name,
                  style: AppTextStyles.w500_14.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDepartureTimeCard(
    BuildContext context,
    PoolCreateState state,
    PoolCreateCubit cubit,
    Color cardBg,
    Color borderColor,
  ) {
    final format = DateFormat('EEE, MMM d • h:mm a');
    final formattedTime = format.format(state.departureTime);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                color: AppColors.primaryColor,
                size: 20.r,
              ),
              SizedBox(width: 8.w),
              Text(
                'Target Departure Time',
                style: AppTextStyles.w700_14.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: () async {
              final now = DateTime.now();
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: state.departureTime,
                firstDate: now,
                lastDate: now.add(const Duration(days: 7)),
              );
              if (pickedDate != null && context.mounted) {
                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(state.departureTime),
                );
                if (pickedTime != null) {
                  final newDateTime = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );
                  cubit.setDepartureTime(newDateTime);
                }
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      formattedTime,
                      style: AppTextStyles.w600_14.copyWith(
                        color: AppColors.primaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.edit_calendar_rounded,
                    color: AppColors.primaryColor,
                    size: 18.r,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
          // Quick presets
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _buildPresetChip(
                label: '+15m',
                onTap: () => cubit.setDepartureTime(
                  DateTime.now().add(const Duration(minutes: 15)),
                ),
              ),
              _buildPresetChip(
                label: '+30m',
                onTap: () => cubit.setDepartureTime(
                  DateTime.now().add(const Duration(minutes: 30)),
                ),
              ),
              _buildPresetChip(
                label: '+1h',
                onTap: () => cubit.setDepartureTime(
                  DateTime.now().add(const Duration(hours: 1)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip({
    required String label,
    required VoidCallback onTap,
  }) {
    return ActionChip(
      label: Text(label, style: AppTextStyles.w500_12),
      onPressed: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _buildSeatsNeededCard(
    BuildContext context,
    PoolCreateState state,
    PoolCreateCubit cubit,
    Color cardBg,
    Color borderColor,
  ) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seats You Need',
                  style: AppTextStyles.w700_14.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Number of seats for you & companions',
                  style: AppTextStyles.w400_12.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton.outlined(
                onPressed: state.seatsNeeded > 1
                    ? () => cubit.setSeatsNeeded(state.seatsNeeded - 1)
                    : null,
                icon: const Icon(Icons.remove),
                iconSize: 18.r,
                constraints: BoxConstraints.tightFor(width: 36.r, height: 36.r),
                padding: EdgeInsets.zero,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  '${state.seatsNeeded}',
                  style: AppTextStyles.w700_16.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              IconButton.outlined(
                onPressed: state.seatsNeeded < state.maxPassengers
                    ? () => cubit.setSeatsNeeded(state.seatsNeeded + 1)
                    : null,
                icon: const Icon(Icons.add),
                iconSize: 18.r,
                constraints: BoxConstraints.tightFor(width: 36.r, height: 36.r),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
