import 'package:flutter/material.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/widgets/custom_header_button.dart';
import 'package:mashena_rider/features/home/presentation/common/widgets/confirmation_button.dart';
import 'package:mashena_rider/features/home/presentation/common/widgets/proximity_warning.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/pick_shared_trip_address_cubit/pick_shared_trip_address_cubit.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/pick_shared_trip_address_cubit/pick_shared_trip_address_state.dart';
import 'shared_trip_address_field_row.dart';

class SharedTripAddressInputSection extends StatelessWidget {
  const SharedTripAddressInputSection({
    super.key,
    required this.pickupController,
    required this.destController,
    required this.state,
    required this.cubit,
    required this.onOpenMap,
    required this.onConfirm,
  });

  final TextEditingController pickupController;
  final TextEditingController destController;
  final PickSharedTripAddressState state;
  final PickSharedTripAddressCubit cubit;
  final void Function(BuildContext context, int index) onOpenMap;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomHeaderButton(),
          const SizedBox(height: 24),
          SharedTripAddressFieldRow(
            index: 0,
            controller: pickupController,
            hint: S.of(context).homeCurrentLocation,
            isActive: state.pickupPlace != null,
            state: state,
            cubit: cubit,
            onOpenMap: onOpenMap,
          ),
          const SizedBox(height: 12),
          SharedTripAddressFieldRow(
            index: 1,
            controller: destController,
            hint: S.of(context).enterDestination,
            isActive: state.destinationPlace != null,
            state: state,
            cubit: cubit,
            onOpenMap: onOpenMap,
          ),
          if (state.warningMessage != null) ...[
            const SizedBox(height: 8),
            ProximityWarning(message: state.warningMessage!),
          ],
          const SizedBox(height: 24),
          ConfirmationButton(
            isEnabled: state.isReadyToConfirm,
            onPressed: onConfirm,
          ),
        ],
      ),
    );
  }
}
