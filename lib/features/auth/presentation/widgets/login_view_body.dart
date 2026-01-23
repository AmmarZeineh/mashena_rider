import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_context_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/utils/app_images.dart';
import 'package:mashena_rider/core/utils/responsive_utils.dart';
import 'package:mashena_rider/core/widgets/custom_elvated_button.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          child: Column(
            crossAxisAlignment: .center,
            mainAxisAlignment: .center,
            children: [
              SizedBox(
                width: double.infinity,
                height: context.screenHeight * 0.1,
              ),
              Image.asset(
                Assets.imagesLogo,
                height: context.screenHeight * 0.25,
              ),
              SizedBox(height: AppResponsive.h(10)),
              Text(S.of(context).authLogin, style: AppTextStyles.w400_38),
              SizedBox(height: 45),
              Text(
                S.of(context).enterYourNumberLogin,
                style: AppTextStyles.w400_16,
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: CustomFormField(hint: S.of(context).authPhone),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: CustomElevatedButton(
                    title: S.of(context).authSendCode,
                    onPressed: () {},
                  ),
                ),
              ),
              Spacer(),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${S.of(context).authDontHaveAnAccount} ',
                      style: AppTextStyles.w400_16,
                    ),
                    TextSpan(
                      text: S.of(context).authSignUp,
                      style: AppTextStyles.w600_16.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    super.key,
    this.prefix,
    this.sufix,
    required this.hint,
  });
  final Widget? prefix, sufix;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefix: prefix,
        suffix: sufix,
        hint: Text(
          hint,
          style: AppTextStyles.w400_14.copyWith(color: AppColors.textGrey),
        ),
        focusedBorder: _buildBorder(),
        border: _buildBorder(),
        enabledBorder: _buildBorder(),
      ),
    );
  }

  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.textFieldBorderColor),
      borderRadius: BorderRadius.circular(50),
    );
  }
}
