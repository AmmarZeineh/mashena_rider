import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mashena_rider/core/common/extensions/pinput_theme_x.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/utils/responsive_utils.dart';
import 'package:mashena_rider/core/widgets/custom_elvated_button.dart';
import 'package:mashena_rider/core/widgets/custom_header_button.dart';
import 'package:pinput/pinput.dart';

class VerificationViewBody extends StatelessWidget {
  const VerificationViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final pinputTheme = Theme.of(context).extension<PinputTheme>()!;
    final email = GoRouterState.of(context).extra as String;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            CustomHeaderButton(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: .center,
                children: [
                  SizedBox(height: AppResponsive.screenHeight * 0.1),
                  Text(S.of(context).otpTitle, style: AppTextStyles.w600_20),
                  SizedBox(height: 7),
                  Text(
                    S.of(context).otpSubtitle(email),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.w400_16.copyWith(
                      color: AppColors.textGrey,
                    ),
                  ),
                  SizedBox(height: 48),
                  Pinput(
                    length: 6,
                    defaultPinTheme: PinTheme(
                      width: pinputTheme.width,
                      height: pinputTheme.height,
                      textStyle: pinputTheme.textStyle,
                      decoration: pinputTheme.defaultDecoration,
                    ),
                    focusedPinTheme: PinTheme(
                      width: pinputTheme.width,
                      height: pinputTheme.height,
                      textStyle: pinputTheme.textStyle,
                      decoration: pinputTheme.focusedDecoration,
                    ),
                    submittedPinTheme: PinTheme(
                      width: pinputTheme.width,
                      height: pinputTheme.height,
                      textStyle: pinputTheme.textStyle,
                      decoration: pinputTheme.submittedDecoration,
                    ),
                    errorPinTheme: PinTheme(
                      width: pinputTheme.width,
                      height: pinputTheme.height,
                      textStyle: pinputTheme.textStyle,
                      decoration: pinputTheme.errorDecoration,
                    ),
                    onCompleted: (pin) {},
                  ),
                  SizedBox(width: double.infinity, height: 25),
                  Text(
                    S.of(context).otpResend,
                    style: AppTextStyles.w600_16.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: 100.h),
                  SizedBox(
                    width: double.infinity,
                    child: CustomElevatedButton(
                      title: S.of(context).otpVerifyNow,
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
