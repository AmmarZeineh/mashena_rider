import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:mashena_rider/features/settings/presentation/cubits/settings_state.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          s.settingsSettings,
          style: AppTextStyles.w600_18.copyWith(color: colorScheme.onSurface),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final cubit = context.read<SettingsCubit>();

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Theme Section
                  _SectionHeader(
                    icon: Icons.palette_outlined,
                    title: s.settingsTheme,
                    subtitle: s.settingsThemeSubtitle,
                  ),
                  SizedBox(height: 12.h),
                  _ThemeCard(
                    title: s.settingsThemeSystem,
                    description: s.settingsThemeSystemDesc,
                    icon: Icons.brightness_auto_rounded,
                    isSelected: state.themeMode == ThemeMode.system,
                    onTap: () => cubit.setThemeMode(ThemeMode.system),
                  ),
                  SizedBox(height: 10.h),
                  _ThemeCard(
                    title: s.settingsThemeLight,
                    description: s.settingsThemeLightDesc,
                    icon: Icons.light_mode_rounded,
                    isSelected: state.themeMode == ThemeMode.light,
                    onTap: () => cubit.setThemeMode(ThemeMode.light),
                  ),
                  SizedBox(height: 10.h),
                  _ThemeCard(
                    title: s.settingsThemeDark,
                    description: s.settingsThemeDarkDesc,
                    icon: Icons.dark_mode_rounded,
                    isSelected: state.themeMode == ThemeMode.dark,
                    onTap: () => cubit.setThemeMode(ThemeMode.dark),
                  ),

                  SizedBox(height: 28.h),

                  // Language Section
                  _SectionHeader(
                    icon: Icons.translate_rounded,
                    title: s.settingsLanguage,
                    subtitle: s.settingsLanguageSubtitle,
                  ),
                  SizedBox(height: 12.h),
                  _LanguageCard(
                    title: s.settingsLanguageEnglish,
                    subtitle: 'English',
                    flagText: '🇺🇸',
                    isSelected: state.locale?.languageCode == 'en' ||
                        (state.locale == null &&
                            Localizations.localeOf(context).languageCode ==
                                'en'),
                    onTap: () => cubit.setLocale(const Locale('en')),
                  ),
                  SizedBox(height: 10.h),
                  _LanguageCard(
                    title: s.settingsLanguageArabic,
                    subtitle: 'العربية',
                    flagText: '🇸🇦',
                    isSelected: state.locale?.languageCode == 'ar' ||
                        (state.locale == null &&
                            Localizations.localeOf(context).languageCode ==
                                'ar'),
                    onTap: () => cubit.setLocale(const Locale('ar')),
                  ),

                  SizedBox(height: 28.h),

                  // App Info Card
                  _AppInfoCard(isDark: isDark),
                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withValues(alpha: isDark ? 0.18 : 0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: AppColors.primaryColor, size: 20.r),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.w700_16.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: AppTextStyles.w400_12.copyWith(
                  color: isDark
                      ? colorScheme.onSurfaceVariant
                      : AppColors.textGrey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = isSelected
        ? AppColors.primaryColor.withValues(alpha: isDark ? 0.16 : 0.08)
        : (isDark
            ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.6)
            : Colors.white);

    final borderColor = isSelected
        ? AppColors.primaryColor
        : (isDark
            ? colorScheme.outlineVariant.withValues(alpha: 0.25)
            : AppColors.borderColor.withValues(alpha: 0.6));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: borderColor, width: isSelected ? 1.8 : 1),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.18)
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.primaryColor.withValues(
                        alpha: isDark ? 0.15 : 0.08,
                      ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.primaryColor,
                size: 22.r,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.w600_16.copyWith(
                      color: isSelected
                          ? (isDark ? colorScheme.onSurface : AppColors.primaryColor)
                          : colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    description,
                    style: AppTextStyles.w400_12.copyWith(
                      color: isDark
                          ? colorScheme.onSurfaceVariant
                          : AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primaryColor : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : (isDark
                          ? colorScheme.outlineVariant
                          : AppColors.borderColor),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 14.r, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String flagText;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.title,
    required this.subtitle,
    required this.flagText,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = isSelected
        ? AppColors.primaryColor.withValues(alpha: isDark ? 0.16 : 0.08)
        : (isDark
            ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.6)
            : Colors.white);

    final borderColor = isSelected
        ? AppColors.primaryColor
        : (isDark
            ? colorScheme.outlineVariant.withValues(alpha: 0.25)
            : AppColors.borderColor.withValues(alpha: 0.6));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: borderColor, width: isSelected ? 1.8 : 1),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.18)
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColor.withValues(
                        alpha: isDark ? 0.3 : 0.15,
                      )
                    : (isDark
                        ? colorScheme.surfaceContainerHighest
                        : const Color(0xFFF1F5F9)),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                flagText,
                style: TextStyle(fontSize: 22.sp),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.w600_16.copyWith(
                      color: isSelected
                          ? (isDark ? colorScheme.onSurface : AppColors.primaryColor)
                          : colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.w400_12.copyWith(
                      color: isDark
                          ? colorScheme.onSurfaceVariant
                          : AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primaryColor : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : (isDark
                          ? colorScheme.outlineVariant
                          : AppColors.borderColor),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 14.r, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _AppInfoCard extends StatelessWidget {
  final bool isDark;

  const _AppInfoCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.5)
            : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? colorScheme.outlineVariant.withValues(alpha: 0.2)
              : AppColors.borderColor.withValues(alpha: 0.5),
        ),
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
            child: Icon(
              Icons.info_outline_rounded,
              color: AppColors.primaryColor,
              size: 22.r,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.settingsAppInfo,
                  style: AppTextStyles.w600_14.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  s.settingsAppDescription,
                  style: AppTextStyles.w400_12.copyWith(
                    color: isDark
                        ? colorScheme.onSurfaceVariant
                        : AppColors.textGrey,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  s.settingsAppVersion,
                  style: AppTextStyles.w500_11.copyWith(
                    color: AppColors.primaryColor,
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
