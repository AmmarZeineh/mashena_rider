import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/notifications/domain/entities/notification_item.dart';
import 'package:mashena_rider/features/notifications/presentation/widgets/notification_type_helper.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItem item;

  const NotificationCard({super.key, required this.item});

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final dt = dateTime.toLocal();
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = monthNames[dt.month - 1];
    final day = dt.day.toString().padLeft(2, '0');
    final hour = (dt.hour % 12 == 0 ? 12 : dt.hour % 12).toString().padLeft(
      2,
      '0',
    );
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$day $month ${dt.year} • $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final typeHelper = NotificationTypeHelper.fromType(item.type);
    final formattedTime = _formatDateTime(item.createdAt);
    final isUnread = !item.isRead;

    final tripId = item.metadata?['tripId'];
    final rideRequestId = item.metadata?['rideRequestId'];
    final amount = item.metadata?['amount'];

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isUnread
            ? AppColors.primaryColor.withValues(alpha: 0.03)
            : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isUnread
              ? AppColors.primaryColor.withValues(alpha: 0.3)
              : AppColors.borderColor.withValues(alpha: 0.5),
          width: isUnread ? 1.2 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Type Icon
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: typeHelper.backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  typeHelper.icon,
                  color: typeHelper.iconColor,
                  size: 22.r,
                ),
              ),
            ),
            SizedBox(width: 14.w),

            // Notification Content (Title, Body, Metadata, Timestamp)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row with Unread Dot
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: AppTextStyles.w600_16.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (isUnread) ...[
                        SizedBox(width: 8.w),
                        Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 6.h),

                  // Body Message
                  Text(
                    item.body,
                    style: AppTextStyles.w400_14.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.75),
                      height: 1.35,
                    ),
                  ),

                  // Metadata Badges (if any)
                  if (tripId != null ||
                      rideRequestId != null ||
                      amount != null) ...[
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 6.h,
                      children: [
                        if (tripId != null && tripId is int)
                          _MetadataChip(
                            label: s.notificationTripId(tripId),
                            icon: Icons.tag_rounded,
                          ),
                        if (rideRequestId != null && rideRequestId is int)
                          _MetadataChip(
                            label: s.notificationRideRequestId(rideRequestId),
                            icon: Icons.confirmation_number_outlined,
                          ),
                        if (amount != null)
                          _MetadataChip(
                            label: '$amount ${s.appCurrency}',
                            icon: Icons.account_balance_wallet_outlined,
                            isAccent: true,
                          ),
                      ],
                    ),
                  ],

                  SizedBox(height: 8.h),

                  // Timestamp
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 12.r,
                        color: AppColors.textGrey,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        formattedTime,
                        style: AppTextStyles.w500_12.copyWith(
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetadataChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isAccent;

  const _MetadataChip({
    required this.label,
    required this.icon,
    this.isAccent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: isAccent
            ? AppColors.shieldGreen.withValues(alpha: 0.1)
            : AppColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12.r,
            color: isAccent ? AppColors.shieldGreen : AppColors.primaryColor,
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: AppTextStyles.w600_12.copyWith(
              color: isAccent ? AppColors.shieldGreen : AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
