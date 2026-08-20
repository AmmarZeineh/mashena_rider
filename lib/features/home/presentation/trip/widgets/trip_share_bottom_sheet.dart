import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/home/presentation/common/widgets/custom_drag_handle.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/trip_share_cubit/trip_share_cubit.dart';

import 'trip_share_sheet_components/share_action_buttons.dart';
import 'trip_share_sheet_components/share_header_section.dart';
import 'trip_share_sheet_components/share_url_card.dart';

class TripShareBottomSheet extends StatefulWidget {
  const TripShareBottomSheet({super.key, required this.rideRequestId});

  final int rideRequestId;

  @override
  State<TripShareBottomSheet> createState() => _TripShareBottomSheetState();
}

class _TripShareBottomSheetState extends State<TripShareBottomSheet> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<TripShareCubit>();
    if (cubit.state is TripShareInitial) {
      cubit.shareTrip(widget.rideRequestId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final s = S.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 30,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 12.h),
            const CustomDragHandle(),
            SizedBox(height: 20.h),
            const ShareHeaderSection(),
            SizedBox(height: 24.h),
            BlocBuilder<TripShareCubit, TripShareState>(
              builder: (context, state) {
                if (state is TripShareLoading) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(color: colorScheme.primary),
                          SizedBox(height: 12.h),
                          Text(
                            s.commonLoading,
                            style: AppTextStyles.w500_14.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is TripShareError) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Column(
                      children: [
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.w500_14.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () {
                            context.read<TripShareCubit>().shareTrip(
                              widget.rideRequestId,
                            );
                          },
                          child: Text(s.commonRetry),
                        ),
                      ],
                    ),
                  );
                }

                if (state is TripShareLoaded || state is TripShareRevoking) {
                  final tripShare = state is TripShareLoaded
                      ? state.tripShare
                      : (state as TripShareRevoking).tripShare;
                  final isRevoking = state is TripShareRevoking;

                  return Column(
                    children: [
                      ShareUrlCard(shareUrl: tripShare.shareUrl),
                      SizedBox(height: 24.h),
                      ShareActionButtons(
                        shareUrl: tripShare.shareUrl,
                        isRevoking: isRevoking,
                        onRevokePressed: () {
                          context.read<TripShareCubit>().revokeShareTrip(
                            widget.rideRequestId,
                          );
                        },
                      ),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
