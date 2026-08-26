import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/utils/toast_helper.dart';
import '../cubits/pool_discovery_cubit/pool_discovery_cubit.dart';
import '../cubits/pool_discovery_cubit/pool_discovery_state.dart';
import '../models/pool_discovery_args.dart';
import '../widgets/pool_suggestion_card.dart';

class PoolDiscoveryView extends StatelessWidget {
  final PoolDiscoveryArgs args;

  const PoolDiscoveryView({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<PoolDiscoveryCubit>(param1: args)..fetchSuggestions(),
      child: const _PoolDiscoveryViewBody(),
    );
  }
}

class _PoolDiscoveryViewBody extends StatelessWidget {
  const _PoolDiscoveryViewBody();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PoolDiscoveryCubit>();
    final args = cubit.args;

    return BlocConsumer<PoolDiscoveryCubit, PoolDiscoveryState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          context.showErrorToast(state.errorMessage!);
        }

        if (state.joinedRoom != null) {
          context.showSuccessToast('Joined pool room successfully!');
          context.pushReplacement(
            AppRoutes.poolLobbyPath,
            extra: state.joinedRoom!.id,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Pool Transport'),
            centerTitle: true,
            elevation: 0,
          ),
          body: ModalProgressHUD(
            inAsyncCall: state.isJoining,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Location overview card
                    _buildRouteHeader(context, args),
                    SizedBox(height: 16.h),
                    Text(
                      'Matching Pools Nearby',
                      style: AppTextStyles.w700_16.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Expanded(child: _buildBodyContent(context, state, cubit)),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomBar(context, args),
        );
      },
    );
  }

  Widget _buildRouteHeader(BuildContext context, PoolDiscoveryArgs args) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? Theme.of(context).colorScheme.surfaceContainerHigh
        : Colors.white;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? Colors.white12 : AppColors.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.trip_origin_rounded,
                color: AppColors.shieldGreen,
                size: 18.r,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  args.pickup.name,
                  style: AppTextStyles.w500_14.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            child: const Divider(height: 1),
          ),
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: AppColors.errorColor,
                size: 18.r,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  args.destination.name,
                  style: AppTextStyles.w500_14.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent(
    BuildContext context,
    PoolDiscoveryState state,
    PoolDiscoveryCubit cubit,
  ) {
    if (state.isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 16.h),
            Text(
              'Searching for matching pool lobbies...',
              style: AppTextStyles.w500_14.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    if (state.rooms.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400.w),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80.r,
                    height: 80.r,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.groups_3_rounded,
                      size: 40.r,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'No Pool Lobbies Found',
                    style: AppTextStyles.w700_18.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Be the first to create a pool lobby and other passengers traveling your direction will join you!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.w400_14.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        context.push(
                          AppRoutes.poolCreatePath,
                          extra: cubit.args,
                        );
                      },
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Create Pool Lobby'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => cubit.fetchSuggestions(),
      child: ListView.builder(
        itemCount: state.rooms.length,
        itemBuilder: (context, index) {
          final room = state.rooms[index];
          return PoolSuggestionCard(
            room: room,
            onJoin: () => cubit.joinRoom(roomId: room.id),
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, PoolDiscoveryArgs args) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: FilledButton.icon(
          onPressed: () {
            context.push(AppRoutes.poolCreatePath, extra: args);
          },
          icon: const Icon(Icons.add_circle_outline_rounded),
          label: const Text('Create New Pool Lobby'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
        ),
      ),
    );
  }
}
