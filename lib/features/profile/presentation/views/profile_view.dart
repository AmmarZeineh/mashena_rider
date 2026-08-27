import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/utils/toast_helper.dart';
import 'package:mashena_rider/features/auth/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:mashena_rider/features/profile/domain/entities/rider_profile.dart';
import 'package:mashena_rider/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:mashena_rider/features/profile/presentation/cubits/profile_state.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = getIt<ProfileCubit>();
        final authState = context.read<AuthCubit>().state;
        authState.maybeWhen(
          authenticated: (session) {
            cubit.getProfile(session.user.id);
          },
          orElse: () {},
        );
        return cubit;
      },
      child: const _ProfileViewContent(),
    );
  }
}

class _ProfileViewContent extends StatelessWidget {
  const _ProfileViewContent();

  void _fetchProfile(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    authState.maybeWhen(
      authenticated: (session) {
        context.read<ProfileCubit>().getProfile(session.user.id);
      },
      orElse: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          s.drawerMyAccount,
          style: AppTextStyles.w700_18.copyWith(color: colorScheme.onSurface),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          state.maybeWhen(
            error: (failure) =>
                context.showErrorToast(failure.rawMessage ?? s.commonError),
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
            error: (_) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48.r,
                    color: AppColors.errorColor,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    s.commonError,
                    style: AppTextStyles.w600_16.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    onPressed: () => _fetchProfile(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(s.commonRetry),
                  ),
                ],
              ),
            ),
            loaded: (profile) => SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProfileAvatarHeader(profile: profile),
                  SizedBox(height: 24.h),
                  if (profile.ratingAvg != null ||
                      profile.ratingCount != null) ...[
                    _ProfileRatingCard(profile: profile),
                    SizedBox(height: 14.h),
                  ],
                  _ProfileInfoCard(
                    label: s.profileName,
                    value: profile.fullName,
                    icon: Icons.person_outline_rounded,
                  ),
                  SizedBox(height: 12.h),
                  _ProfileInfoCard(
                    label: s.email,
                    value: profile.email,
                    icon: Icons.email_outlined,
                  ),
                  SizedBox(height: 12.h),
                  _ProfileInfoCard(
                    label: s.authPhone,
                    value: profile.phoneNumber,
                    icon: Icons.phone_outlined,
                  ),
                  if (profile.canceledTripsCount != null &&
                      profile.canceledTripsCount! > 0) ...[
                    SizedBox(height: 12.h),
                    _ProfileInfoCard(
                      label: s.tripCancelled,
                      value: profile.canceledTripsCount.toString(),
                      icon: Icons.cancel_outlined,
                    ),
                  ],
                  SizedBox(height: 24.h),
                ],
              ),
            ),
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

class _ProfileAvatarHeader extends StatelessWidget {
  final RiderProfile profile;

  const _ProfileAvatarHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryColor.withValues(
                  alpha: isDark ? 0.4 : 0.2,
                ),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 46.r,
              backgroundColor: AppColors.primaryColor.withValues(
                alpha: isDark ? 0.2 : 0.1,
              ),
              child: Icon(
                Icons.person_rounded,
                size: 48.r,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            profile.fullName,
            style: AppTextStyles.w700_20.copyWith(color: colorScheme.onSurface),
          ),
          SizedBox(height: 4.h),
          Text(
            profile.email,
            style: AppTextStyles.w400_14.copyWith(
              color: isDark ? colorScheme.onSurfaceVariant : AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileRatingCard extends StatelessWidget {
  final RiderProfile profile;

  const _ProfileRatingCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    final ratingString = profile.ratingAvg != null
        ? profile.ratingAvg!.toStringAsFixed(1)
        : '-';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.7)
            : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? colorScheme.outlineVariant.withValues(alpha: 0.25)
              : AppColors.borderColor.withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: const Color(
                0xFFFBBF24,
              ).withValues(alpha: isDark ? 0.2 : 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.star_rounded,
              color: const Color(0xFFF59E0B),
              size: 24.r,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.driverRating,
                  style: AppTextStyles.w400_12.copyWith(
                    color: isDark
                        ? colorScheme.onSurfaceVariant
                        : AppColors.textGrey,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Text(
                      ratingString,
                      style: AppTextStyles.w700_18.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (profile.ratingCount != null) ...[
                      SizedBox(width: 6.w),
                      Text(
                        '(${profile.ratingCount})',
                        style: AppTextStyles.w500_12.copyWith(
                          color: isDark
                              ? colorScheme.onSurfaceVariant
                              : AppColors.textGrey,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProfileInfoCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.7)
            : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? colorScheme.outlineVariant.withValues(alpha: 0.25)
              : AppColors.borderColor.withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(
                alpha: isDark ? 0.18 : 0.1,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 22.r),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.w400_12.copyWith(
                    color: isDark
                        ? colorScheme.onSurfaceVariant
                        : AppColors.textGrey,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: AppTextStyles.w600_16.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
