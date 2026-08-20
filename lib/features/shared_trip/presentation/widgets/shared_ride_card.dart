import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/shared_ride_room_entity.dart';
import 'package:mashena_rider/features/shared_trip/presentation/widgets/ride_card/shared_ride_card_driver.dart';
import 'package:mashena_rider/features/shared_trip/presentation/widgets/ride_card/shared_ride_card_footer.dart';
import 'package:mashena_rider/features/shared_trip/presentation/widgets/ride_card/shared_ride_card_header.dart';
import 'package:mashena_rider/features/shared_trip/presentation/widgets/ride_card/shared_ride_card_notes.dart';
import 'package:mashena_rider/features/shared_trip/presentation/widgets/ride_card/shared_ride_card_route.dart';

class SharedRideCard extends StatelessWidget {
  final SharedRideRoomEntity room;

  const SharedRideCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = isDark ? colorScheme.surfaceContainerLow : Colors.white;
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.3)
        : AppColors.borderColor.withValues(alpha: 0.6);

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            context.push(AppRoutes.sharedTripRoomDetailsPath, extra: room.id);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header (Departure time + Status badge)
              SharedRideCardHeader(room: room),

              _CardDivider(color: borderColor),

              // 2. Route section (Origin -> Connector/metrics -> Destination)
              SharedRideCardRoute(room: room),

              // 2.1 Notes Chip (if provided)
              SharedRideCardNotes(notes: room.notes),

              _CardDivider(color: borderColor),

              // 3. Driver & Vehicle Info
              SharedRideCardDriver(driver: room.driver, vehicle: room.vehicle),

              _CardDivider(color: borderColor),

              // 4. Footer (Available seats + Fare per seat)
              SharedRideCardFooter(room: room),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardDivider extends StatelessWidget {
  final Color color;

  const _CardDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, thickness: 0.5, color: color);
  }
}
