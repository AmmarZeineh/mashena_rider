import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/common/extensions/responsive_context_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/l10n/validation_localizer.dart';
import 'package:mashena_rider/core/utils/snack_bars.dart';
import 'package:mashena_rider/core/utils/validators.dart';
import 'package:mashena_rider/core/widgets/custom_elvated_button.dart';
import 'package:mashena_rider/core/widgets/custom_form_field.dart';
import 'package:mashena_rider/features/auth/presentation/blocs/signup_bloc/signup_bloc.dart';
import 'package:mashena_rider/features/auth/presentation/widgets/signup_footer.dart';
import 'package:mashena_rider/features/auth/presentation/widgets/signup_view_header.dart';

class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  String? email, phone, name, password, confirmPassword;

  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _enableAutoValidate() {
    if (_autovalidateMode == AutovalidateMode.disabled) {
      setState(() => _autovalidateMode = AutovalidateMode.always);
    }
  }

  void _submit() {
    _enableAutoValidate();

    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    _formKey.currentState?.save();
    context.read<SignupBloc>().add(
      SignupSubmitted(
        email: email!,
        password: password!,
        fullName: name!,
        phoneNumber: phone!,
      ),
    );
  }

  String? _localizeErr(BuildContext context, err) {
    return err == null ? null : validationText(context, err);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: context.screenHeight * 0.04),
      child: Form(
        key: _formKey,
        autovalidateMode: _autovalidateMode,
        child: Column(
          children: [
            SizedBox(height: context.screenHeight * 0.03),
            SignupViewHeader(logoHeight: context.screenHeight * 0.15),
            const SizedBox(height: 30),

            _Field(
              hint: S.of(context).profileName,
              autofillHints: const [AutofillHints.name],
              keyboardType: TextInputType.name,
              onSaved: (v) => name = v,
              validator: (v) => _localizeErr(context, Validators.required(v)),
            ),
            const SizedBox(height: 20),

            _Field(
              hint: S.of(context).email,
              autofillHints: const [AutofillHints.email],
              keyboardType: TextInputType.emailAddress,
              onSaved: (v) => email = v,
              validator: (v) => _localizeErr(context, Validators.email(v)),
            ),
            const SizedBox(height: 20),

            _Field(
              hint: S.of(context).authPhone,
              autofillHints: const [AutofillHints.telephoneNumber],
              keyboardType: TextInputType.phone,
              onSaved: (v) => phone = v,
              validator: (v) => _localizeErr(context, Validators.phone(v)),
            ),
            const SizedBox(height: 20),

            _Field(
              hint: S.of(context).authPassword,
              controller: _passwordCtrl,
              autofillHints: const [AutofillHints.newPassword],
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              onSaved: (v) => password = v,
              validator: (v) => _localizeErr(context, Validators.password(v)),
              onChanged: (_) {
                if (_autovalidateMode != AutovalidateMode.disabled) {
                  _formKey.currentState?.validate(); // لتحديث confirm
                }
              },
            ),
            const SizedBox(height: 20),

            _Field(
              hint: S.of(context).confirmPassword,
              controller: _confirmCtrl,
              autofillHints: const [AutofillHints.newPassword],
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              onSaved: (v) => confirmPassword = v,
              validator: (v) {
                final e1 = Validators.password(v);
                if (e1 != null) return _localizeErr(context, e1);

                final e2 = Validators.passwordsMatch(_passwordCtrl.text, v);
                return _localizeErr(context, e2);
              },
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                child: BlocConsumer<SignupBloc, SignupState>(
                  listener: (context, state) {
                    if (state is SignupSuccess) {
                      context.pushNamed(AppRoutes.verification);
                    } else if (state is SignupFailure) {
                      showErrorMessage(
                        state.failure.rawMessage ?? 'Unknown',
                        context,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is SignupLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return CustomElevatedButton(
                      title: S.of(context).authSendCode,
                      onPressed: _submit,
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),
            SignupFooter(onTapLogin: () => context.pop()),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.hint,
    this.controller,
    this.autofillHints,
    this.keyboardType,
    this.obscureText = false,
    this.onSaved,
    this.validator,
    this.onChanged,
  });

  final String hint;
  final TextEditingController? controller;
  final List<String>? autofillHints;
  final TextInputType? keyboardType;
  final bool obscureText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: CustomFormField(
        controller: controller,
        autofillHints: autofillHints,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onSaved: onSaved,
        validator: validator,
        onChanged: onChanged,
        hint: hint,
      ),
    );
  }
}
