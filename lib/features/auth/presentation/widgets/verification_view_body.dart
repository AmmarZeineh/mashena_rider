import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/common/extensions/pinput_theme_x.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/enums/otp_channel.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/utils/responsive_utils.dart';
import 'package:mashena_rider/core/utils/toast_helper.dart';
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

  final ValueNotifier<bool> _isOtpValid = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _otpController.addListener(_onOtpChanged);
  }

  void _onOtpChanged() {
    final otp = _otpController.text.trim();
    final valid = otp.length == 6;
    if (valid != _isOtpValid.value) {
      _isOtpValid.value = valid;
    }
  }

  @override
  void dispose() {
    _otpController.removeListener(_onOtpChanged);
    _otpController.dispose();
    _isOtpValid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pinputTheme = Theme.of(context).extension<PinputTheme>()!;
    final extra = GoRouterState.of(context).extra;

    final args = (extra is Map<String, dynamic>) ? extra : <String, dynamic>{};
    final email = args['email'] as String? ?? '';
    final phone = args['phone'] as String? ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomHeaderButton(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: AppResponsive.screenHeight * 0.1),
                  Text(S.of(context).otpTitle, style: AppTextStyles.w600_20),
                  const SizedBox(height: 7),
                  Text(
                    S.of(context).otpSubtitle(email),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.w400_16.copyWith(
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 48),

                  Pinput(
                    controller: _otpController,
                    length: 6,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                  ),

                  const SizedBox(width: double.infinity, height: 25),
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
                          context.showSuccessToast(
                            S.of(context).authOtpSuccess,
                          );

                          context.pushReplacementNamed(AppRoutes.login);
                        } else if (state is VerifyOtpFailure) {
                          context.showErrorToast(
                            state.failure.rawMessage ??
                                S.of(context).apiUnknownError,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is VerifyOtpLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ValueListenableBuilder<bool>(
                          valueListenable: _isOtpValid,
                          builder: (context, valid, _) {
                            return CustomElevatedButton(
                              title: S.of(context).otpVerifyNow,
                              onPressed: valid
                                  ? () {
                                      final otp = _otpController.text.trim();

                                      context.read<VerifyOtpBloc>().add(
                                        VerifyOtpSubmitted(
                                          email: email,
                                          code: otp,
                                          phoneNumber: phone,
                                          channel: OtpChannel.email.name,
                                        ),
                                      );
                                    }
                                  : null,
                            );
                          },
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
