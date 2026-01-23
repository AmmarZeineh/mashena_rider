import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mashena_rider/core/common/extensions/responsive_context_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/l10n/validation_localizer.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/utils/app_images.dart';
import 'package:mashena_rider/core/utils/validators.dart';
import 'package:mashena_rider/core/widgets/custom_elvated_button.dart';
import 'package:mashena_rider/core/widgets/custom_form_field.dart';

class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? email, password, name;

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
                    Image.asset(
                      Assets.imagesLogo,
                      height: context.screenHeight * 0.25,
                    ),

                    Text(
                      S.of(context).authRegister,
                      style: AppTextStyles.w400_38,
                    ),

                    const SizedBox(height: 45),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: CustomFormField(
                        autofillHints: const [AutofillHints.name],
                        onSaved: (value) => name = value,
                        validator: (value) {
                          final err = Validators.required(value);
                          return err == null
                              ? null
                              : validationText(context, err);
                        },
                        hint: S.of(context).profileName,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    SizedBox(height: 20),
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
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: CustomFormField(
                        autofillHints: const [AutofillHints.password],
                        onSaved: (value) => password = value,
                        validator: (value) {
                          final err = Validators.password(value);
                          return err == null
                              ? null
                              : validationText(context, err);
                        },
                        hint: S.of(context).authPassword,
                        keyboardType: TextInputType.visiblePassword,
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
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () => context.pop(),
                                child: Text(
                                  S.of(context).authSignUp,
                                  style: AppTextStyles.w600_16.copyWith(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
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
