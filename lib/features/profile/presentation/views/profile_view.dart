import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/utils/toast_helper.dart';
import 'package:mashena_rider/features/auth/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:mashena_rider/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:mashena_rider/features/profile/presentation/cubits/profile_state.dart';

import 'package:mashena_rider/app/di/injector.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account', style: AppTextStyles.w600_18),
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          state.maybeWhen(
            error: (failure) => context.showErrorToast(
              failure.rawMessage ?? 'Error loading profile',
            ),
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (profile) => SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primaryColor.withValues(
                        alpha: 0.1,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildProfileItem(
                    'Full Name',
                    profile.fullName,
                    Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  _buildProfileItem(
                    'Email',
                    profile.email,
                    Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildProfileItem(
                    'Phone Number',
                    profile.phoneNumber,
                    Icons.phone_outlined,
                  ),
                  const SizedBox(height: 16),
                  if (profile.ratingAvg != null)
                    _buildProfileItem(
                      'Rating',
                      profile.ratingAvg.toString(),
                      Icons.star_border,
                    ),
                  const SizedBox(height: 16),
                  if (profile.ratingCount != null)
                    _buildProfileItem(
                      'Total Ratings',
                      profile.ratingCount.toString(),
                      Icons.people_outline,
                    ),
                ],
              ),
            ),
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  Widget _buildProfileItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.w400_12.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(value, style: AppTextStyles.w600_16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
