import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/common/extensions/responsive_context_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/l10n/validation_localizer.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/utils/app_images.dart';
import 'package:mashena_rider/core/utils/responsive_utils.dart';
import 'package:mashena_rider/core/utils/validators.dart';
import 'package:mashena_rider/core/widgets/custom_elvated_button.dart';
import 'package:mashena_rider/core/widgets/custom_form_field.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? email;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                autovalidateMode: autovalidateMode,
                child: Column(
                  children: [
                    SizedBox(height: context.screenHeight * 0.1),

                    Image.asset(
                      Assets.imagesLogo,
                      height: context.screenHeight * 0.25,
                    ),

                    SizedBox(height: AppResponsive.h(10)),
                    Text(S.of(context).authLogin, style: AppTextStyles.w400_38),

                    const SizedBox(height: 45),

                    Text(
                      S.of(context).enterYourEmailLogin,
                      style: AppTextStyles.w400_16,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: CustomFormField(
                        autofillHints: const [AutofillHints.email],
                        onSaved: (value) => email = value,
                        validator: (value) {
                          final err = Validators.email(value);
                          return err == null
                              ? null
                              : validationText(context, err);
                        },
                        hint: S.of(context).email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SizedBox(
                        width: double.infinity,
                        child: CustomElevatedButton(
                          title: S.of(context).authSendCode,
                          onPressed: () {
                            setState(
                              () => autovalidateMode = AutovalidateMode.always,
                            );

                            final ok =
                                _formKey.currentState?.validate() ?? false;
                            if (!ok) return;

                            _formKey.currentState?.save();
                          },
                        ),
                      ),
                    ),

                    const Expanded(child: SizedBox(height: 16)),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${S.of(context).authDontHaveAnAccount} ',
                              style: AppTextStyles.w400_16,
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () =>
                                    context.pushNamed(AppRoutes.signup),
                              text: S.of(context).authSignUp,
                              style: AppTextStyles.w600_16.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
