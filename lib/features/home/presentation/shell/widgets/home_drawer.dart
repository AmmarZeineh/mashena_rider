import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/auth/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:mashena_rider/features/profile/presentation/views/profile_view.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  void _showLogoutDialog(BuildContext context) {
    bool isLoading = false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(S.of(context).authLogout),
            content: isLoading
                ? SizedBox(
                    height: 100.h,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Text(S.of(context).logoutConfirmationMessage),
            actions: isLoading
                ? []
                : [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text(S.of(context).commonCancel),
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
                      child: Text(S.of(context).logoutThisDevice),
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
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: Text(S.of(context).logoutAllDevices),
                    ),
                  ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.primaryColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              CircleAvatar(
                radius: 40.r,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 16),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final name = state.maybeWhen(
                    authenticated: (session) => session.user.fullName,
                    orElse: () => S.of(context).drawerGuestUser,
                  );
                  return Text(
                    name,
                    style: AppTextStyles.w700_20.copyWith(color: Colors.white),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white24, thickness: 1),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DrawerItem(
                        title: S.of(context).drawerMyAccount,
                        icon: Icons.person_outline,
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ProfileView(),
                            ),
                          );
                        },
                      ),
                      _DrawerItem(
                        title: S.of(context).drawerFavourites,
                        icon: Icons.favorite_border,
                        onTap: () {},
                      ),
                      _DrawerItem(
                        title: S.of(context).drawerFaq,
                        icon: Icons.help_outline,
                        onTap: () {},
                      ),
                      _DrawerItem(
                        title: S.of(context).drawerSos,
                        icon: Icons.sos,
                        onTap: () {},
                      ),
                      _DrawerItem(
                        title: S.of(context).drawerMakeComplaints,
                        icon: Icons.report_problem_outlined,
                        onTap: () {},
                      ),
                      _DrawerItem(
                        title: S.of(context).drawerNotification,
                        icon: Icons.notifications_none,
                        onTap: () {},
                      ),
                      _DrawerItem(
                        title: S.of(context).drawerAbout,
                        icon: Icons.info_outline,
                        onTap: () {},
                      ),
                      _DrawerItem(
                        title: S.of(context).drawerPrivacyPolicy,
                        icon: Icons.privacy_tip_outlined,
                        onTap: () {},
                      ),
                      _DrawerItem(
                        title: S.of(context).drawerTermsCondition,
                        icon: Icons.description_outlined,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(color: Colors.white24, thickness: 1),
              const SizedBox(height: 8),
              _DrawerItem(
                title: S.of(context).authLogout,
                icon: Icons.logout,
                onTap: () => _showLogoutDialog(context),
              ),
              const SizedBox(height: 16),
            ],
          ),
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
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.white70, size: 24),
      title: Text(
        title,
        style: AppTextStyles.w500_16.copyWith(color: Colors.white),
      ),
      onTap: onTap,
      dense: true,
      visualDensity: const VisualDensity(vertical: -1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
