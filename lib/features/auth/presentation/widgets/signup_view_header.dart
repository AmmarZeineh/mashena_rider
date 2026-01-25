import 'package:flutter/material.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/utils/app_images.dart';

class SignupViewHeader extends StatelessWidget {
  const SignupViewHeader({super.key, required this.logoHeight});

  final double logoHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(Assets.imagesLogo, height: logoHeight),
        Text(S.of(context).authRegister, style: AppTextStyles.w400_38),
      ],
    );
  }
}
