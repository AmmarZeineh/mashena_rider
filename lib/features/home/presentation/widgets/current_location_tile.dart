import 'package:flutter/material.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/features/home/presentation/cubits/pick_address_cubit/pick_address_cubit.dart';

class CurrentLocationTile extends StatelessWidget {
  const CurrentLocationTile({super.key, required this.cubit});

  final PickAddressCubit cubit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.my_location),
      title: Text(S.of(context).homeCurrentLocation),
      onTap: () {
        cubit.useDeviceLocation(
          language:
              WidgetsBinding.instance.platformDispatcher.locale.languageCode,
        );
        FocusScope.of(context).unfocus();
      },
    );
  }
}
