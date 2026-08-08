import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/core/constants/app_constants.dart';
import 'package:mashena_rider/core/widgets/custom_elevated_button.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_submission_response.dart';
import 'package:mashena_rider/features/home/presentation/booking/cubits/ride_booking_cubit/ride_booking_cubit.dart';
import 'package:mashena_rider/features/home/presentation/common/models/confirmed_ride_flow_result.dart';
import 'package:mashena_rider/features/home/presentation/common/widgets/custom_drag_handle.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/home/domain/entities/trip_completed.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/trip_rating_cubit.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/trip_rating_state.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/l10n/failure_localizer.dart';
import 'package:mashena_rider/core/utils/toast_helper.dart';

import 'ride_confirmed_sheet_components/driver_card.dart';

class TripRatingBottomSheet extends StatefulWidget {
  const TripRatingBottomSheet({
    super.key,
    required this.rideResult,
    required this.submissionResponse,
    this.tripCompletedData,
  });

  final ConfirmedRideFlowResult rideResult;
  final RideSubmissionResponse submissionResponse;
  final TripCompleted? tripCompletedData;

  @override
  State<TripRatingBottomSheet> createState() => _TripRatingBottomSheetState();
}

class _TripRatingBottomSheetState extends State<TripRatingBottomSheet> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TripRatingCubit>(),
      child: BlocConsumer<TripRatingCubit, TripRatingState>(
        listenWhen: (previous, current) =>
            (current.errorMessage != null &&
                previous.errorMessage != current.errorMessage) ||
            (current.validationError != null &&
                previous.validationError != current.validationError) ||
            (current.isSuccess && !previous.isSuccess),
        listener: (context, state) {
          if (state.errorMessage != null) {
            // API/repository error — localized via failureText
            context.showErrorToast(failureText(context, state.errorMessage!));
          }
          if (state.validationError != null) {
            // Local UI validation — map constant to localized string
            final String message = switch (state.validationError) {
              AppConstants.errorSelectRatingScore =>
                S.of(context).ratingPleaseSelectScore,
              AppConstants.errorSelectRatingTag =>
                S.of(context).ratingPleaseSelectTag,
              _ => state.validationError!,
            };
            context.showErrorToast(message);
          }
          if (state.isSuccess) {
            // Dismiss or clear ride flow
            context.read<RideBookingCubit>().clearBooking();
          }
        },
        builder: (context, state) {
          final colorScheme = Theme.of(context).colorScheme;
          final destination = widget.rideResult.destinationPlaces.isNotEmpty
              ? widget.rideResult.destinationPlaces.first.name
              : 'Unknown Destination';

          String duration;
          if (widget.tripCompletedData != null &&
              widget.tripCompletedData!.durationSec != null) {
            final durationMin = (widget.tripCompletedData!.durationSec! / 60)
                .ceil();
            duration = durationMin.toString();
          } else {
            duration = widget.submissionResponse.durationMin.toStringAsFixed(0);
          }
          final price = widget.submissionResponse.estimatedFare.toStringAsFixed(
            2,
          );
          final currency = widget.submissionResponse.currency;
          final activeTripId =
              widget.tripCompletedData?.tripId ??
              widget
                  .submissionResponse
                  .rideRequestId; // We need trip ID, fallback to ride request ID if missing or map correctly

          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 30,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 12.h),
                    const CustomDragHandle(),
                    SizedBox(height: 16.h),

                    Text(
                      S.of(context).rideTripEnded,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.w700_20.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Trip Summary
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.3,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            _buildSummaryRow(
                              Icons.location_on,
                              "To",
                              destination,
                              colorScheme,
                            ),
                            SizedBox(height: 12.h),
                            _buildSummaryRow(
                              Icons.access_time,
                              S.of(context).rideDuration,
                              "$duration min",
                              colorScheme,
                            ),
                            SizedBox(height: 12.h),
                            _buildSummaryRow(
                              Icons.payments,
                              S.of(context).rideEstFare,
                              "$price $currency",
                              colorScheme,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Driver Card
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: const DriverCard(),
                    ),
                    SizedBox(height: 24.h),

                    Text(
                      S.of(context).ratingRateDriver,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.w600_16,
                    ),
                    SizedBox(height: 12.h),

                    // Rating Stars
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          iconSize: 40.w,
                          icon: Icon(
                            index < state.currentScore
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () {
                            context.read<TripRatingCubit>().setScore(
                              (index + 1).toDouble(),
                            );
                          },
                        );
                      }),
                    ),
                    SizedBox(height: 16.h),

                    // Tags Section
                    if (state.isLoadingTags)
                      const Center(child: CircularProgressIndicator())
                    else if (state.currentAvailableTags.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: state.currentAvailableTags.map((tag) {
                            final isSelected = state.selectedTagIds.contains(
                              tag.id,
                            );
                            return FilterChip(
                              label: Text(tag.name ?? tag.code),
                              selected: isSelected,
                              onSelected: (_) {
                                context.read<TripRatingCubit>().toggleTag(
                                  tag.id,
                                );
                              },
                              selectedColor: AppColors.primaryColor.withValues(
                                alpha: 0.2,
                              ),
                              checkmarkColor: AppColors.primaryColor,
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],

                    // Comment Field
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: TextField(
                        controller: _commentController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: S.of(context).ratingLeaveComment,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: colorScheme.outline),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: colorScheme.outline.withValues(alpha: 0.5),
                            ),
                          ),
                          filled: true,
                          fillColor: colorScheme.surface,
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Buttons (Submit & Skip / Don't Rate)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(
                        bottom: MediaQuery.of(context).padding.bottom + 16.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomElevatedButton(
                            title: S.of(context).ratingSubmitRating,
                            isLoading: state.isSubmitting,
                            onPressed: () {
                              context.read<TripRatingCubit>().submitRating(
                                tripId: activeTripId,
                                comment: _commentController.text,
                              );
                            },
                          ),
                          SizedBox(height: 12.h),
                          CustomElevatedButton(
                            title: S.of(context).ratingDontRate,
                            backgroundColor:
                                colorScheme.surfaceContainerHighest,
                            textColor: colorScheme.onSurfaceVariant,
                            onPressed: state.isSubmitting
                                ? null
                                : () {
                                    context
                                        .read<RideBookingCubit>()
                                        .clearBooking();
                                  },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(
    IconData icon,
    String label,
    String value,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20.w, color: colorScheme.onSurfaceVariant),
        SizedBox(width: 8.w),
        Text(
          label,
          style: AppTextStyles.w500_14.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyles.w600_14.copyWith(color: colorScheme.onSurface),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
