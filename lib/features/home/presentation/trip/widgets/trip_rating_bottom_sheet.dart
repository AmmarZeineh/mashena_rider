import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_submission_response.dart';
import 'package:mashena_rider/features/home/presentation/shell/cubits/home_cubit/home_cubit.dart';
import 'package:mashena_rider/features/home/presentation/common/models/confirmed_ride_flow_result.dart';
import 'package:mashena_rider/features/home/presentation/common/widgets/custom_drag_handle.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';

import 'ride_confirmed_sheet_components/driver_card.dart';

class TripRatingBottomSheet extends StatefulWidget {
  const TripRatingBottomSheet({
    super.key,
    required this.rideResult,
    required this.submissionResponse,
  });

  final ConfirmedRideFlowResult rideResult;
  final RideSubmissionResponse submissionResponse;

  @override
  State<TripRatingBottomSheet> createState() => _TripRatingBottomSheetState();
}

class _TripRatingBottomSheetState extends State<TripRatingBottomSheet> {
  int _selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final destination = widget.rideResult.destinationPlaces.isNotEmpty
        ? widget.rideResult.destinationPlaces.first.name
        : 'Unknown Destination';
    final duration = widget.submissionResponse.durationMin.toStringAsFixed(0);
    final price = widget.submissionResponse.estimatedFare.toStringAsFixed(2);
    final currency = widget.submissionResponse.currency;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
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
                "Trip Completed",
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
                        "Time",
                        "$duration min",
                        colorScheme,
                      ),
                      SizedBox(height: 12.h),
                      _buildSummaryRow(
                        Icons.payments,
                        "Price",
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
                "Rate your driver",
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
                      index < _selectedRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedRating = index + 1;
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: 16.h),

              // Comment Field
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: TextField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Add an optional comment...",
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

              // Submit Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(
                  bottom: MediaQuery.of(context).padding.bottom + 16.h,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    context.read<HomeCubit>().submitRating(
                      _selectedRating.toDouble(),
                      _commentController.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Submit Rating",
                    style: AppTextStyles.w600_16.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
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
            style: AppTextStyles.w600_14.copyWith(
              color: colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
