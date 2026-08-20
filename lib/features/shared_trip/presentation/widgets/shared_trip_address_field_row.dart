import 'package:flutter/material.dart';
import 'package:mashena_rider/features/home/presentation/address/widgets/pick_location_circular_container.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/pick_shared_trip_address_cubit/pick_shared_trip_address_cubit.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/pick_shared_trip_address_cubit/pick_shared_trip_address_state.dart';

class SharedTripAddressFieldRow extends StatelessWidget {
  const SharedTripAddressFieldRow({
    super.key,
    required this.index,
    required this.controller,
    required this.hint,
    required this.isActive,
    required this.state,
    required this.cubit,
    required this.onOpenMap,
  });

  final int index;
  final TextEditingController controller;
  final String hint;
  final bool isActive;
  final PickSharedTripAddressState state;
  final PickSharedTripAddressCubit cubit;
  final void Function(BuildContext context, int index) onOpenMap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        PickLocationCircularContainer(isActive: isActive),
        const SizedBox(width: 16),
        Expanded(
          child: Focus(
            onFocusChange: (hasFocus) {
              if (hasFocus) cubit.setActiveField(index);
            },
            child: TextField(
              controller: controller,
              onChanged: (value) {
                final placeName = index == 0
                    ? state.pickupPlace?.name
                    : state.destinationPlace?.name;

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
                hintText: hint,
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
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
        IconButton(
          icon: const Icon(Icons.map),
          onPressed: () => onOpenMap(context, index),
        ),
      ],
    );
  }
}
