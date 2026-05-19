import 'package:flutter/material.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

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
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                'Frank Smith',
                style: AppTextStyles.w700_20.copyWith(color: Colors.white),
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
                        title: 'My Account',
                        icon: Icons.person_outline,
                        onTap: () {},
                      ),
                      _DrawerItem(
                        title: 'Favourites',
                        icon: Icons.favorite_border,
                        onTap: () {},
                      ),
                      _DrawerItem(
                        title: 'FAQ',
                        icon: Icons.help_outline,
                        onTap: () {},
                      ),
                      _DrawerItem(title: 'SOS', icon: Icons.sos, onTap: () {}),
                      _DrawerItem(
                        title: 'Make Complaints',
                        icon: Icons.report_problem_outlined,
                        onTap: () {},
                      ),
                      _DrawerItem(
                        title: 'Notification',
                        icon: Icons.notifications_none,
                        onTap: () {},
                      ),
                      _DrawerItem(
                        title: 'About',
                        icon: Icons.info_outline,
                        onTap: () {},
                      ),
                      _DrawerItem(
                        title: 'Privacy Policy',
                        icon: Icons.privacy_tip_outlined,
                        onTap: () {},
                      ),
                      _DrawerItem(
                        title: 'Terms & Condition',
                        icon: Icons.description_outlined,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(color: Colors.white24, thickness: 1),
              const SizedBox(height: 8),
              _DrawerItem(title: 'Logout', icon: Icons.logout, onTap: () {}),
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
