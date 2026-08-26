import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/moderation/domain/entities/user_account_status.dart';
import 'package:mashena_rider/features/moderation/presentation/cubits/appeals_history_cubit/appeals_history_cubit.dart';
import 'package:mashena_rider/features/moderation/presentation/cubits/moderation_overview_cubit/moderation_overview_cubit.dart';
import 'package:mashena_rider/features/moderation/presentation/cubits/moderation_overview_cubit/moderation_overview_state.dart';
import 'package:mashena_rider/features/moderation/presentation/cubits/penalties_history_cubit/penalties_history_cubit.dart';
import 'package:mashena_rider/features/moderation/presentation/cubits/violations_history_cubit/violations_history_cubit.dart';
import 'package:mashena_rider/features/moderation/presentation/widgets/account_status_card.dart';
import 'package:mashena_rider/features/moderation/presentation/widgets/appeals_tab_view.dart';
import 'package:mashena_rider/features/moderation/presentation/widgets/moderation_metric_card.dart';
import 'package:mashena_rider/features/moderation/presentation/widgets/overview_tab_view.dart';
import 'package:mashena_rider/features/moderation/presentation/widgets/penalties_tab_view.dart';
import 'package:mashena_rider/features/moderation/presentation/widgets/violations_tab_view.dart';

class ModerationView extends StatelessWidget {
  const ModerationView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<ModerationOverviewCubit>()..fetchOverview(),
        ),
        BlocProvider(
          create: (_) =>
              getIt<PenaltiesHistoryCubit>()..fetchInitialPenalties(),
        ),
        BlocProvider(
          create: (_) =>
              getIt<ViolationsHistoryCubit>()..fetchInitialViolations(),
        ),
        BlocProvider(
          create: (_) =>
              getIt<AppealsHistoryCubit>()..fetchInitialAppeals(),
        ),
      ],
      child: const _ModerationContent(),
    );
  }
}

class _ModerationContent extends StatefulWidget {
  const _ModerationContent();

  @override
  State<_ModerationContent> createState() => _ModerationContentState();
}

class _ModerationContentState extends State<_ModerationContent>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _refreshAll(BuildContext context) {
    context.read<ModerationOverviewCubit>().fetchOverview();
    context.read<PenaltiesHistoryCubit>().fetchInitialPenalties();
    context.read<ViolationsHistoryCubit>().fetchInitialViolations();
    context.read<AppealsHistoryCubit>().fetchInitialAppeals();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocListener<ModerationOverviewCubit, ModerationOverviewState>(
      listenWhen: (p, c) =>
          c.realTimeNoticeMessage != null &&
          p.realTimeNoticeMessage != c.realTimeNoticeMessage,
      listener: (context, state) {
        if (state.realTimeNoticeMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.realTimeNoticeMessage!),
              backgroundColor: AppColors.primaryColor,
              duration: const Duration(seconds: 4),
            ),
          );
          context.read<ModerationOverviewCubit>().clearRealTimeNotice();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.lightScaffold,
        appBar: AppBar(
          title: Text(s.moderationTitle, style: AppTextStyles.w600_18),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: s.commonRetry,
              onPressed: () => _refreshAll(context),
            ),
          ],
        ),
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: BlocBuilder<
                    ModerationOverviewCubit,
                    ModerationOverviewState
                  >(
                    builder: (context, state) {
                      final overview = state.overview;
                      final accountStatus =
                          overview?.accountStatus ?? UserAccountStatus.active;
                      final warningCount = overview?.warningCount ?? 0;
                      final totalViolations =
                          overview?.totalViolationsCount ?? 0;
                      final activePenaltiesCount =
                          overview?.activePenalties.length ?? 0;
                      final activeRestrictionsCount =
                          overview?.activeRestrictions.length ?? 0;

                      return Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Account Status Card
                            AccountStatusCard(accountStatus: accountStatus),
                            SizedBox(height: 14.h),

                            // 4 Metrics Grid
                            Row(
                              children: [
                                Expanded(
                                  child: ModerationMetricCard(
                                    title: s.moderationWarningsCount,
                                    count: warningCount,
                                    icon: Icons.warning_amber_rounded,
                                    accentColor: const Color(0xFFD97706),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: ModerationMetricCard(
                                    title: s.moderationViolationsCount,
                                    count: totalViolations,
                                    icon: Icons.report_problem_outlined,
                                    accentColor: const Color(0xFFEA580C),
                                    onTap: () => _tabController.animateTo(2),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Expanded(
                                  child: ModerationMetricCard(
                                    title: s.moderationPenaltiesCount,
                                    count: activePenaltiesCount,
                                    icon: Icons.gavel_rounded,
                                    accentColor: AppColors.errorColor,
                                    onTap: () => _tabController.animateTo(1),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: ModerationMetricCard(
                                    title: s.moderationRestrictionsCount,
                                    count: activeRestrictionsCount,
                                    icon: Icons.lock_clock_rounded,
                                    accentColor: const Color(0xFF7C3AED),
                                    onTap: () => _tabController.animateTo(0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverTabBarDelegate(
                    TabBar(
                      controller: _tabController,
                      labelColor: AppColors.primaryColor,
                      unselectedLabelColor: AppColors.textGrey,
                      labelStyle: AppTextStyles.w600_14,
                      unselectedLabelStyle: AppTextStyles.w500_14,
                      indicatorColor: AppColors.primaryColor,
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: [
                        Tab(text: s.moderationOverviewTab),
                        Tab(text: s.moderationPenaltiesTab),
                        Tab(text: s.moderationViolationsTab),
                        Tab(text: s.moderationAppealsTab),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Overview Tab
                BlocBuilder<ModerationOverviewCubit, ModerationOverviewState>(
                  builder: (context, state) {
                    if (state.status == ModerationOverviewStatus.loading &&
                        state.overview == null) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    }

                    if (state.status == ModerationOverviewStatus.failure &&
                        state.overview == null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              size: 48.r,
                              color: AppColors.errorColor,
                            ),
                            SizedBox(height: 12.h),
                            Text(s.commonError, style: AppTextStyles.w600_16),
                            SizedBox(height: 12.h),
                            ElevatedButton(
                              onPressed: () => context
                                  .read<ModerationOverviewCubit>()
                                  .fetchOverview(),
                              child: Text(s.commonRetry),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state.overview == null) {
                      return const SizedBox.shrink();
                    }

                    return RefreshIndicator(
                      onRefresh: () => context
                          .read<ModerationOverviewCubit>()
                          .fetchOverview(),
                      color: AppColors.primaryColor,
                      child: OverviewTabView(
                        overview: state.overview!,
                        onRefreshNeeded: () => _refreshAll(context),
                      ),
                    );
                  },
                ),

                // Tab 2: Penalties History Tab
                PenaltiesTabView(
                  onRefreshOverview: () => context
                      .read<ModerationOverviewCubit>()
                      .fetchOverview(),
                ),

                // Tab 3: Violations History Tab
                const ViolationsTabView(),

                // Tab 4: Appeals History Tab
                const AppealsTabView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  const _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF3F4F6),
            width: 1,
          ),
        ),
      ),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
