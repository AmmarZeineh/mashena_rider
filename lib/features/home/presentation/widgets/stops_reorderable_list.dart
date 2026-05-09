import 'package:flutter/material.dart';
import 'package:mashena_rider/features/home/presentation/cubits/pick_address_cubit/pick_address_cubit.dart';
import 'package:mashena_rider/features/home/presentation/cubits/pick_address_cubit/pick_address_state.dart';
import 'stop_field_row.dart';

class StopsReorderableList extends StatelessWidget {
  const StopsReorderableList({
    super.key,
    required this.state,
    required this.cubit,
    required this.pickupController,
    required this.destControllers,
    required this.onOpenMap,
  });

  final PickAddressState state;
  final PickAddressCubit cubit;
  final TextEditingController pickupController;
  final List<TextEditingController> destControllers;
  final Function(BuildContext, int) onOpenMap;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      child: ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 1 + state.destinations.length,
        onReorder: cubit.reorderAllStops,
        itemBuilder: (context, index) {
          final isPickup = index == 0;
          return StopFieldRow(
            key: ValueKey('stop_$index'),
            index: index,
            isPickup: isPickup,
            state: state,
            cubit: cubit,
            controller: isPickup
                ? pickupController
                : destControllers[index - 1],
            onOpenMap: () => onOpenMap(context, index),
          );
        },
      ),
    );
  }
}
