import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/utils/toast_helper.dart';
import 'package:mashena_rider/features/coupons/presentation/cubits/coupons_cubit.dart';
import 'package:mashena_rider/features/coupons/presentation/cubits/coupons_state.dart';
import 'package:mashena_rider/features/coupons/presentation/widgets/coupon_history_list_tab.dart';
import 'package:mashena_rider/features/coupons/presentation/widgets/coupon_input_card.dart';
import 'package:mashena_rider/features/coupons/presentation/widgets/coupon_list_tab.dart';

class CouponsView extends StatelessWidget {
  const CouponsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CouponsCubit>()..fetchAllData(),
      child: const _CouponsViewContent(),
    );
  }
}

class _CouponsViewContent extends StatefulWidget {
  const _CouponsViewContent();

  @override
  State<_CouponsViewContent> createState() => _CouponsViewContentState();
}

class _CouponsViewContentState extends State<_CouponsViewContent>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onApplyCoupon(BuildContext context, String code) {
    context.read<CouponsCubit>().activateCoupon(code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightScaffold,
      appBar: AppBar(
        title: Text(S.of(context).drawerCoupons, style: AppTextStyles.w600_18),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<CouponsCubit, CouponsState>(
        listener: (context, state) {
          if (state.activationStatus == ActivationStatus.success) {
            final code = state.newlyActivatedCoupon?.coupon.code ?? '';
            context.showSuccessToast(
              '${S.of(context).couponAppliedSuccess}${code.isNotEmpty ? ': $code' : ''}',
            );
            context.read<CouponsCubit>().resetActivationState();
          } else if (state.activationStatus == ActivationStatus.error) {
            final errorMessage =
                state.activationFailure?.rawMessage ??
                S.of(context).commonError;
            context.showErrorToast(errorMessage);
            context.read<CouponsCubit>().resetActivationState();
          }
        },
        builder: (context, state) {
          final isGlobalLoading = state.status == CouponsStatus.loading;
          final isActivating =
              state.activationStatus == ActivationStatus.loading;
          final activeCoupons = state.activeCoupons;

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                children: [
                  // Coupon Input Section
                  CouponInputCard(
                    isLoading: isActivating,
                    onApply: (code) => _onApplyCoupon(context, code),
                  ),
                  SizedBox(height: 16.h),

                  // TabBar Header
                  Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.borderColor.withValues(alpha: 0.5),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: AppColors.textGrey,
                      labelStyle: AppTextStyles.w600_14,
                      unselectedLabelStyle: AppTextStyles.w500_14,
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(
                          height: 40.h,
                          child: Center(
                            child: Text(
                              S.of(context).activeCouponsSection,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Tab(
                          height: 40.h,
                          child: Center(
                            child: Text(
                              S.of(context).couponHistorySection,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // TabBar Content
                  Expanded(
                    child: isGlobalLoading
                        ? const Center(child: CircularProgressIndicator())
                        : TabBarView(
                            controller: _tabController,
                            children: [
                              // Active Coupons Tab
                              CouponListTab(
                                coupons: activeCoupons,
                                emptyMessage: S.of(context).noActiveCoupons,
                              ),

                              // Coupon History Tab
                              CouponHistoryListTab(
                                historyItems: state.historyItems,
                                emptyMessage: S.of(context).noCouponHistory,
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
