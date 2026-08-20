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

    final args = SharedTripRoomsArgs(pickup: pickup, destination: destination);

    if (widget.isEditing) {
      context.pop(args);
    } else {
      context.push(AppRoutes.sharedTripRoomsPath, extra: args);
    }
  }
}
