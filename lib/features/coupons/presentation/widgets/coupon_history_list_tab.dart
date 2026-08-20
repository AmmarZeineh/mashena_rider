import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/features/coupons/domain/entities/coupon_history_item_entity.dart';
import 'package:mashena_rider/features/coupons/presentation/widgets/coupon_empty_state.dart';
import 'package:mashena_rider/features/coupons/presentation/widgets/coupon_history_card.dart';

class CouponHistoryListTab extends StatelessWidget {
  final List<CouponHistoryItemEntity> historyItems;
  final String emptyMessage;

  const CouponHistoryListTab({
    super.key,
    required this.historyItems,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (historyItems.isEmpty) {
      return CouponEmptyState(emptyMessage: emptyMessage);
    }

    return ListView.builder(
      itemCount: historyItems.length,
      padding: EdgeInsets.only(top: 4.h, bottom: 16.h),
      itemBuilder: (context, index) {
        return CouponHistoryCard(historyItem: historyItems[index]);
      },
    );
  }
}
