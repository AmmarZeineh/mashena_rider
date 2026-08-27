import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import '../../domain/entities/pool_member_entity.dart';
import '../../domain/entities/pool_room_entity.dart';

class PoolMemberAvatarGroup extends StatelessWidget {
  final PoolRoomEntity room;
  final int? currentUserId;

  const PoolMemberAvatarGroup({
    super.key,
    required this.room,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? Theme.of(context).colorScheme.surfaceContainerHigh
        : Colors.white;
    final borderColor = isDark ? Colors.white12 : AppColors.borderColor;

    final occupiedCount = room.currentPassengers;
    final totalCapacity = room.maxPassengers;
    final emptyCount = (totalCapacity - occupiedCount).clamp(0, totalCapacity);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.people_alt_rounded,
                    color: AppColors.primaryColor,
                    size: 20.r,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    s.poolPassengersRoster,
                    style: AppTextStyles.w700_14.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  s.poolOccupiedSeats(occupiedCount, totalCapacity),
                  style: AppTextStyles.w600_12.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: room.members.length + emptyCount,
            separatorBuilder: (_, _) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              if (index < room.members.length) {
                final member = room.members[index];
                return _buildMemberTile(context, member);
              } else {
                return _buildEmptySeatTile(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMemberTile(BuildContext context, PoolMemberEntity member) {
    final s = S.of(context);
    final isCreator = member.riderProfileId == room.creatorRiderProfileId;
    final isMe = member.riderProfileId == currentUserId;

    final name = member.riderName ?? s.poolPassengerNumber(member.id);
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'P';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isMe
            ? AppColors.primaryColor.withValues(alpha: 0.08)
            : Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isMe
              ? AppColors.primaryColor.withValues(alpha: 0.3)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: isCreator
                ? const Color(0xFFFFB300)
                : isMe
                ? AppColors.primaryColor
                : Colors.blueGrey,
            backgroundImage:
                member.riderAvatarUrl != null &&
                    member.riderAvatarUrl!.isNotEmpty
                ? NetworkImage(member.riderAvatarUrl!)
                : null,
            child:
                member.riderAvatarUrl == null || member.riderAvatarUrl!.isEmpty
                ? Text(
                    initial,
                    style: AppTextStyles.w700_14.copyWith(color: Colors.white),
                  )
                : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        isMe ? s.poolPassengerYou(name) : name,
                        style: AppTextStyles.w600_14.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCreator) ...[
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB300).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          s.poolHost,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 10.sp,
                            color: const Color(0xFFD87D00),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  s.poolSeatsRequested(member.seatsNeeded),
                  style: AppTextStyles.w400_12.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Color(0xFF2E7D32),
              size: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySeatTile(BuildContext context) {
    final s = S.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white12
              : Colors.grey.shade300,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor: Colors.grey.withValues(alpha: 0.15),
            child: Icon(
              Icons.person_add_alt_1_outlined,
              size: 16.r,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            s.poolWaitingForPassenger,
            style: AppTextStyles.w400_12.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
