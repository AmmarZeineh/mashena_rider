import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/common/extensions/pinput_theme_x.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/utils/responsive_utils.dart';
import 'package:mashena_rider/core/utils/snack_bars.dart';
import 'package:mashena_rider/core/widgets/custom_elvated_button.dart';
import 'package:mashena_rider/core/widgets/custom_header_button.dart';
import 'package:mashena_rider/features/auth/presentation/blocs/verify_otp_bloc/verify_otp_bloc.dart';
import 'package:pinput/pinput.dart';

class VerificationViewBody extends StatefulWidget {
  const VerificationViewBody({super.key});

  @override
  State<VerificationViewBody> createState() => _VerificationViewBodyState();
}

class _VerificationViewBodyState extends State<VerificationViewBody> {
  final _otpController = TextEditingController();
  bool _isOtpValid = false;

  @override
  void initState() {
    super.initState();
    _otpController.addListener(() {
      final otp = _otpController.text.trim();
      final valid = otp.length == 6;
      if (valid != _isOtpValid) {
        setState(() => _isOtpValid = valid);
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pinputTheme = Theme.of(context).extension<PinputTheme>()!;
    final args = GoRouterState.of(context).extra as Map<String, dynamic>;
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
                    S.of(context).otpSubtitle(args['email']),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.w400_16.copyWith(
                      color: AppColors.textGrey,
                    ),
                  ),
                  SizedBox(height: 48),
                  Pinput(
                    keyboardType: TextInputType.number,

                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ], // إذا بدك تشدد
                    controller: _otpController,
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
                    onCompleted: (pin) {
                      _otpController.text = pin;
                    },
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
                    child: BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
                      listener: (context, state) {
                        if (state is VerifyOtpSuccess) {
                          context.pushReplacementNamed(AppRoutes.login);
                          showSuccessMessage(
                            S.of(context).authOtpSuccess,
                            context,
                          );
                        }
                        if (state is VerifyOtpFailure) {
                          showErrorMessage(
                            state.failure.rawMessage ??
                                S.of(context).apiUnknownError,
                            context,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is VerifyOtpLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return CustomElevatedButton(
                          title: S.of(context).otpVerifyNow,
                          onPressed: _isOtpValid
                              ? () {
                                  final otp = _otpController.text.trim();
                                  context.read<VerifyOtpBloc>().add(
                                    VerifyOtpSubmitted(
                                      email: args['email'],
                                      code: otp,
                                      phoneNumber: args['phone'],
                                      channel: 'email',
                                    ),
                                  );
                                }
                              : null,
                        );
                      },
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
