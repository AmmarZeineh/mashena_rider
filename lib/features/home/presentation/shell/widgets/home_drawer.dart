import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/auth/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:mashena_rider/features/wallet/presentation/cubits/wallet_cubit/wallet_cubit.dart';
import 'package:mashena_rider/features/wallet/presentation/widgets/drawer_wallet_section.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  void _showLogoutDialog(BuildContext context) {
    bool isLoading = false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          final s = S.of(context);
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            title: Text(s.authLogout, style: AppTextStyles.w700_18),
            content: isLoading
                ? SizedBox(
                    height: 80.h,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )
                : Text(
                    s.logoutConfirmationMessage,
                    style: AppTextStyles.w400_14,
                  ),
            actions: isLoading
                ? []
                : [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text(
                        s.commonCancel,
                        style: AppTextStyles.w600_14.copyWith(
                          color: AppColors.textGrey,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        setState(() => isLoading = true);
                        await context.read<AuthCubit>().signOut(
                          allDevices: false,
                        );
                        if (ctx.mounted) {
                          Navigator.of(ctx).pop();
                        }
                      },
                      child: Text(
                        s.logoutThisDevice,
                        style: AppTextStyles.w600_14.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        setState(() => isLoading = true);
                        await context.read<AuthCubit>().signOut(
                          allDevices: true,
                        );
                        if (ctx.mounted) {
                          Navigator.of(ctx).pop();
                        }
                      },
                      child: Text(
                        s.logoutAllDevices,
                        style: AppTextStyles.w600_14.copyWith(
                          color: AppColors.errorColor,
                        ),
                      ),
                    ),
                  ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => getIt<WalletCubit>()..fetchWallet(),
      child: Drawer(
        backgroundColor: colorScheme.surface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.horizontal(
            end: Radius.circular(24.r),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                // User Profile Header Card
                _DrawerUserHeader(
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push(AppRoutes.profilePath);
                  },
                ),
                SizedBox(height: 12.h),
                // Wallet Section
                const DrawerWalletSection(),
                SizedBox(height: 12.h),
                Divider(
                  color: isDark
                      ? colorScheme.outlineVariant.withValues(alpha: 0.25)
                      : AppColors.borderColor.withValues(alpha: 0.5),
                  thickness: 1,
                ),
                SizedBox(height: 8.h),
                // Navigation Items List
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DrawerItem(
                          title: s.drawerMyAccount,
                          icon: Icons.person_outline_rounded,
                          onTap: () {
                            Navigator.of(context).pop();
                            context.push(AppRoutes.profilePath);
                          },
                        ),
                        _DrawerItem(
                          title: s.drawerActiveTrips,
                          icon: Icons.directions_car_filled_outlined,
                          onTap: () {
                            Navigator.of(context).pop();
                            context.push(AppRoutes.activeTripsPath);
                          },
                        ),
                        _DrawerItem(
                          title: s.drawerTripHistory,
                          icon: Icons.history_rounded,
                          onTap: () {
                            Navigator.of(context).pop();
                            context.push(AppRoutes.tripHistoryPath);
                          },
                        ),
                        _DrawerItem(
                          title: s.drawerCoupons,
                          icon: Icons.confirmation_number_outlined,
                          onTap: () {
                            Navigator.of(context).pop();
                            context.push(AppRoutes.couponsPath);
                          },
                        ),
                        _DrawerItem(
                          title: s.drawerNotification,
                          icon: Icons.notifications_none_rounded,
                          onTap: () {
                            Navigator.of(context).pop();
                            context.push(AppRoutes.notificationsPath);
                          },
                        ),
                        _DrawerItem(
                          title: s.drawerModeration,
                          icon: Icons.gavel_rounded,
                          onTap: () {
                            Navigator.of(context).pop();
                            context.push(AppRoutes.moderationPath);
                          },
                        ),
                        SizedBox(height: 6.h),
                        Divider(
                          color: isDark
                              ? colorScheme.outlineVariant.withValues(
                                  alpha: 0.2,
                                )
                              : AppColors.borderColor.withValues(alpha: 0.4),
                          thickness: 1,
                        ),
                        SizedBox(height: 6.h),
                        _DrawerItem(
                          title: s.settingsSettings,
                          icon: Icons.settings_outlined,
                          onTap: () {
                            Navigator.of(context).pop();
                            context.push(AppRoutes.settingsPath);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: isDark
                      ? colorScheme.outlineVariant.withValues(alpha: 0.25)
                      : AppColors.borderColor.withValues(alpha: 0.5),
                  thickness: 1,
                ),
                SizedBox(height: 4.h),
                _DrawerLogoutItem(
                  title: s.authLogout,
                  onTap: () => _showLogoutDialog(context),
                ),
                SizedBox(height: 10.h),
                Center(
                  child: Text(
                    'Mashena Rider • v1.0.0',
                    style: AppTextStyles.w500_11.copyWith(
                      color: isDark
                          ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6)
                          : AppColors.textGrey.withValues(alpha: 0.8),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DrawerUserHeader extends StatelessWidget {
  final VoidCallback onTap;

  const _DrawerUserHeader({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isDark
              ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.6)
              : AppColors.primaryColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark
                ? colorScheme.outlineVariant.withValues(alpha: 0.25)
                : AppColors.primaryColor.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryColor, width: 1.5),
              ),
              child: CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColors.primaryColor.withValues(
                  alpha: isDark ? 0.25 : 0.15,
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 26.r,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final name = state.maybeWhen(
                    authenticated: (session) => session.user.fullName,
                    orElse: () => S.of(context).drawerGuestUser,
                  );
                  final phone = state.maybeWhen(
                    authenticated: (session) => session.user.phoneNumber,
                    orElse: () => '',
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.w700_16.copyWith(
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (phone.isNotEmpty) ...[
                        SizedBox(height: 2.h),
                        Text(
                          phone,
                          style: AppTextStyles.w400_12.copyWith(
                            color: isDark
                                ? colorScheme.onSurfaceVariant
                                : AppColors.textGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14.r,
              color: isDark ? colorScheme.onSurfaceVariant : AppColors.textGrey,
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
        leading: Container(
          width: 36.r,
          height: 36.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withValues(
              alpha: isDark ? 0.18 : 0.08,
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: AppColors.primaryColor, size: 20.r),
        ),
        title: Text(
          title,
          style: AppTextStyles.w500_16.copyWith(color: colorScheme.onSurface),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 12.r,
          color: isDark
              ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6)
              : AppColors.textGrey.withValues(alpha: 0.6),
        ),
        onTap: onTap,
        dense: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}

class _DrawerLogoutItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _DrawerLogoutItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
        leading: Container(
          width: 36.r,
          height: 36.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.errorColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.logout_rounded,
            color: AppColors.errorColor,
            size: 20.r,
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.w600_16.copyWith(color: AppColors.errorColor),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 12.r,
          color: AppColors.errorColor.withValues(alpha: 0.6),
        ),
        onTap: onTap,
        dense: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
