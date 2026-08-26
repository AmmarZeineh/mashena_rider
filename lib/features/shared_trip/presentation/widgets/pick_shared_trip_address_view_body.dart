import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/l10n/failure_localizer.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/utils/toast_helper.dart';
import 'package:mashena_rider/features/home/presentation/common/widgets/custom_divider.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/pick_shared_trip_address_cubit/pick_shared_trip_address_cubit.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/pick_shared_trip_address_cubit/pick_shared_trip_address_state.dart';
import 'package:mashena_rider/features/pool/presentation/models/pool_discovery_args.dart';
import 'package:mashena_rider/features/shared_trip/presentation/models/shared_trip_rooms_args.dart';
import 'shared_trip_address_bottom_section.dart';
import 'shared_trip_address_input_section.dart';

class PickSharedTripAddressViewBody extends StatefulWidget {
  const PickSharedTripAddressViewBody({super.key, this.isEditing = false});

  final bool isEditing;

  @override
  State<PickSharedTripAddressViewBody> createState() =>
      _PickSharedTripAddressViewBodyState();
}

class _PickSharedTripAddressViewBodyState
    extends State<PickSharedTripAddressViewBody> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destController = TextEditingController();

  @override
  void dispose() {
    _pickupController.dispose();
    _destController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PickSharedTripAddressCubit, PickSharedTripAddressState>(
      listener: _onStateChanged,
      builder: (context, state) {
        final cubit = context.read<PickSharedTripAddressCubit>();
        _syncControllers(state);

        return ModalProgressHUD(
          inAsyncCall: state.isCreatingRideRequest,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              SharedTripAddressInputSection(
                pickupController: _pickupController,
                destController: _destController,
                state: state,
                cubit: cubit,
                onOpenMap: _openMapPicker,
                onConfirm: () => _onConfirmLocations(context, state),
              ),
              const SizedBox(height: 16),
              const CustomDivider(),
              const SizedBox(height: 16),
              SharedTripAddressBottomSection(state: state, cubit: cubit),
            ],
          ),
        );
      },
    );
  }

  void _onStateChanged(BuildContext context, PickSharedTripAddressState state) {
    _syncControllers(state);

    if (state.errorMessage != null) {
      context.showErrorToast(failureText(context, state.errorMessage!));
    }
  }

  void _syncControllers(PickSharedTripAddressState state) {
    final isPickupActive = state.activeFieldIndex == 0;
    final isSearching = state.searchQuery.isNotEmpty;

    // Sync pickup controller
    if (state.pickupPlace != null &&
        _pickupController.text != state.pickupPlace!.name) {
      if (!isPickupActive || !isSearching) {
        _pickupController.value = TextEditingValue(
          text: state.pickupPlace!.name,
          selection: TextSelection.collapsed(
            offset: state.pickupPlace!.name.length,
          ),
        );
      }
    } else if (state.pickupPlace == null &&
        _pickupController.text.isNotEmpty &&
        !isSearching) {
      _pickupController.clear();
    }

    // Sync destination controller
    final isDestActive = state.activeFieldIndex == 1;
    if (state.destinationPlace != null &&
        _destController.text != state.destinationPlace!.name) {
      if (!isDestActive || !isSearching) {
        _destController.value = TextEditingValue(
          text: state.destinationPlace!.name,
          selection: TextSelection.collapsed(
            offset: state.destinationPlace!.name.length,
          ),
        );
      }
    } else if (state.destinationPlace == null &&
        _destController.text.isNotEmpty &&
        (!isDestActive || !isSearching)) {
      _destController.clear();
    }
  }

  Future<void> _openMapPicker(BuildContext context, int fieldIndex) async {
    final cubit = context.read<PickSharedTripAddressCubit>();
    cubit.setActiveField(fieldIndex);

    const defaultLoc = MapLatLng(latitude: 33.5153, longitude: 36.2772);
    MapLatLng initialLoc = defaultLoc;

    if (fieldIndex == 0 && cubit.state.pickupPlace != null) {
      initialLoc = MapLatLng(
        latitude: cubit.state.pickupPlace!.latitude,
        longitude: cubit.state.pickupPlace!.longitude,
      );
    } else if (fieldIndex == 1 && cubit.state.destinationPlace != null) {
      initialLoc = MapLatLng(
        latitude: cubit.state.destinationPlace!.latitude,
        longitude: cubit.state.destinationPlace!.longitude,
      );
    }

    final lang = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    final result = await context.push<MapLatLng?>(
      AppRoutes.pickFromMapPath,
      extra: initialLoc,
    );

    if (result != null) {
      cubit.confirmMapSelection(
        result.latitude,
        result.longitude,
        language: lang,
        index: fieldIndex,
      );
    }
  }

  void _onConfirmLocations(
    BuildContext context,
    PickSharedTripAddressState state,
  ) {
    final pickup = state.pickupPlace;
    final destination = state.destinationPlace;
    if (pickup == null || destination == null) return;

    final sharedArgs = SharedTripRoomsArgs(
      pickup: pickup,
      destination: destination,
    );
    final poolArgs = PoolDiscoveryArgs(
      pickup: pickup,
      destination: destination,
    );

    if (widget.isEditing) {
      context.pop(sharedArgs);
      return;
    }

    _showModeSelectionSheet(context, sharedArgs, poolArgs);
  }

  void _showModeSelectionSheet(
    BuildContext context,
    SharedTripRoomsArgs sharedArgs,
    PoolDiscoveryArgs poolArgs,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Choose Pooled Trip Mode',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Join an existing driver route or pool with nearby passengers',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Theme.of(
                      context,
                    ).colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.groups_3_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: const Text(
                  'Passenger Pool Lobby (Recommended)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'Pool with riders, auto-match meeting point, and request a driver together',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  context.push(AppRoutes.poolDiscoveryPath, extra: poolArgs);
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Theme.of(
                      context,
                    ).colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.directions_car_rounded,
                    color: Colors.green,
                  ),
                ),
                title: const Text(
                  'Driver Shared Rides',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'Search rides published by drivers departing along your route',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  context.push(
                    AppRoutes.sharedTripRoomsPath,
                    extra: sharedArgs,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
