import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/features/coupons/domain/entities/user_coupon_entity.dart';
import 'package:mashena_rider/features/coupons/presentation/widgets/coupon_card.dart';
import 'package:mashena_rider/features/coupons/presentation/widgets/coupon_empty_state.dart';

class CouponListTab extends StatelessWidget {
  final List<UserCouponEntity> coupons;
  final String emptyMessage;

  const CouponListTab({
    super.key,
    required this.coupons,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (coupons.isEmpty) {
      return CouponEmptyState(emptyMessage: emptyMessage);
    }

    return ListView.builder(
      itemCount: coupons.length,
      padding: EdgeInsets.only(top: 4.h, bottom: 16.h),
      itemBuilder: (context, index) {
        return CouponCard(userCoupon: coupons[index]);
      },
    );
  }
}
