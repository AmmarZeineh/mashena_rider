import 'package:flutter/material.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/features/home/presentation/address/cubits/pick_address_cubit/pick_address_cubit.dart';
import 'package:mashena_rider/features/home/presentation/address/cubits/pick_address_cubit/pick_address_state.dart';
import 'package:mashena_rider/features/home/presentation/address/widgets/pick_location_circular_container.dart';

class StopFieldRow extends StatelessWidget {
  const StopFieldRow({
    super.key,
    required this.index,
    required this.isPickup,
    required this.state,
    required this.cubit,
    required this.controller,
    required this.onOpenMap,
  });

  final int index;
  final bool isPickup;
  final PickAddressState state;
  final PickAddressCubit cubit;
  final TextEditingController controller;
  final VoidCallback onOpenMap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.drag_indicator, color: Colors.grey),
          const SizedBox(width: 8),
          PickLocationCircularContainer(
            isActive: isPickup
                ? state.pickupPlace != null
                : state.destinations[index - 1] != null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Focus(
              onFocusChange: (hasFocus) {
                if (hasFocus) cubit.setActiveField(index);
              },
              child: TextField(
                controller: controller,
                onChanged: (value) {
                  final placeName = isPickup
                      ? state.pickupPlace?.name
                      : state.destinations[index - 1]?.name;

                  // If deleting and we had a place, clear everything
                  if (placeName != null && value.length < placeName.length) {
                    cubit.clearField(index);
                    controller.clear();
                    return;
                  }

                  cubit.onSearchChanged(
                    value,
                    language: WidgetsBinding
                        .instance
                        .platformDispatcher
                        .locale
                        .languageCode,
                  );
                },
                decoration: InputDecoration(
                  hintText: isPickup
                      ? S.of(context).homeCurrentLocation
                      : S.of(context).enterDestination,
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.map), onPressed: onOpenMap),
          if (!isPickup && state.destinations.length > 1)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => cubit.removeDestination(index - 1),
            ),
        ],
      ),
    );
  }
}
