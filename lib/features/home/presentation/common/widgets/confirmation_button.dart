import 'package:flutter/material.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';

class ConfirmationButton extends StatelessWidget {
  const ConfirmationButton({
    super.key,
    required this.isEnabled,
    required this.onPressed,
  });

  final bool isEnabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: isEnabled ? onPressed : null,
        icon: const Icon(Icons.check_circle_outline),
        label: Text(S.of(context).commonConfirm),
      ),
    );
  }
}
