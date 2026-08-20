import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/l10n/failure_localizer.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/widgets/custom_header_button.dart';
import 'package:mashena_rider/features/home/presentation/address/cubits/pick_address_cubit/pick_address_cubit.dart';
import 'package:mashena_rider/features/home/presentation/address/cubits/pick_address_cubit/pick_address_state.dart';
import 'package:mashena_rider/features/home/domain/entities/place_entity.dart';
import 'package:mashena_rider/features/home/presentation/common/models/confirmed_ride_flow_result.dart';
import 'package:mashena_rider/features/home/presentation/common/widgets/custom_divider.dart';
import 'package:mashena_rider/features/home/presentation/common/widgets/confirmation_button.dart';
import 'package:mashena_rider/features/home/presentation/common/widgets/proximity_warning.dart';
import 'current_location_tile.dart';
import 'saved_places_section.dart';
import 'search_results_section.dart';
import 'stops_reorderable_list.dart';

class PickAddressViewBody extends StatefulWidget {
  const PickAddressViewBody({super.key});

  @override
  State<PickAddressViewBody> createState() => _PickAddressViewBodyState();
}

class _PickAddressViewBodyState extends State<PickAddressViewBody> {
  final TextEditingController _pickupController = TextEditingController();
  final List<TextEditingController> _destControllers = [];

  @override
  void dispose() {
    _pickupController.dispose();
    for (var c in _destControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PickAddressCubit, PickAddressState>(
      listener: _onStateChanged,
      builder: (context, state) {
        final cubit = context.read<PickAddressCubit>();
        if (_destControllers.isEmpty) {
          _syncControllers(state);
        }

        return ModalProgressHUD(
          inAsyncCall: state.isCreatingRideRequest,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              _buildInputSection(context, state, cubit),
              const SizedBox(height: 16),
              const CustomDivider(),
              const SizedBox(height: 16),
              _buildBottomSection(context, state, cubit),
            ],
          ),
        );
      },
    );
  }

  /// Handles state transitions (navigation, errors).
  void _onStateChanged(BuildContext context, PickAddressState state) {
    _syncControllers(state);

    if (state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failureText(context, state.errorMessage!))),
      );
    }

    if (!state.isCreatingRideRequest && state.rideEstimateResponse != null) {
      _navigateToRideEstimates(context, state);
    }
  }

  /// Builds the top section with input fields and confirmation button.
  Widget _buildInputSection(
    BuildContext context,
    PickAddressState state,
    PickAddressCubit cubit,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomHeaderButton(),
          const SizedBox(height: 16),
          const SizedBox(height: 12),
          StopsReorderableList(
            state: state,
            cubit: cubit,
            pickupController: _pickupController,
            destControllers: _destControllers,
            onOpenMap: _openMapPicker,
          ),
          _buildAddStopButton(cubit),
          const SizedBox(height: 8),
          _buildHelpText(context),
          if (state.warningMessage != null)
            ProximityWarning(message: state.warningMessage!),
          const SizedBox(height: 16),
          ConfirmationButton(
            isEnabled: state.isReadyToConfirm,
            onPressed: cubit.confirmRide,
          ),
        ],
      ),
    );
  }

  /// Builds the bottom section (Search results or Saved/Recent).
  Widget _buildBottomSection(
    BuildContext context,
    PickAddressState state,
    PickAddressCubit cubit,
  ) {
    if (state.searchQuery.isNotEmpty) {
      return SearchResultsSection(state: state, cubit: cubit);
    }

    if (state.activeFieldIndex == 0 && state.pickupPlace == null) {
      return CurrentLocationTile(cubit: cubit);
    }

    return const SavedPlacesSection();
  }

  Widget _buildAddStopButton(PickAddressCubit cubit) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        icon: const Icon(Icons.add),
        onPressed: cubit.addDestination,
      ),
    );
  }

  Widget _buildHelpText(BuildContext context) {
    return Text(
      S.of(context).homeNowYouCanAddMultipleStops,
      style: AppTextStyles.w400_12.copyWith(color: Colors.grey),
    );
  }

  void _syncControllers(PickAddressState state) {
    // Only sync if the user is not actively typing in this field
    final isPickupActive = state.activeFieldIndex == 0;
    final isSearching = state.searchQuery.isNotEmpty;

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

    while (_destControllers.length < state.destinations.length) {
      _destControllers.add(TextEditingController());
    }
    while (_destControllers.length > state.destinations.length) {
      _destControllers.removeLast().dispose();
    }

    for (int i = 0; i < state.destinations.length; i++) {
      final place = state.destinations[i];
      final isThisDestActive = state.activeFieldIndex == i + 1;

      if (place != null && _destControllers[i].text != place.name) {
        if (!isThisDestActive || !isSearching) {
          _destControllers[i].value = TextEditingValue(
            text: place.name,
            selection: TextSelection.collapsed(offset: place.name.length),
          );
        }
      } else if (place == null &&
          _destControllers[i].text.isNotEmpty &&
          (!isThisDestActive || !isSearching)) {
        _destControllers[i].clear();
      }
    }
  }

  Future<void> _openMapPicker(BuildContext context, int fieldIndex) async {
    final cubit = context.read<PickAddressCubit>();
    cubit.setActiveField(fieldIndex);

    const defaultLoc = MapLatLng(latitude: 33.5153, longitude: 36.2772);
    MapLatLng initialLoc = defaultLoc;

    if (fieldIndex == 0 && cubit.state.pickupPlace != null) {
      initialLoc = MapLatLng(
        latitude: cubit.state.pickupPlace!.latitude,
        longitude: cubit.state.pickupPlace!.longitude,
      );
    } else if (fieldIndex > 0) {
      final destIndex = fieldIndex - 1;
      final dest = cubit.state.destinations[destIndex];
      if (dest != null) {
        initialLoc = MapLatLng(
          latitude: dest.latitude,
          longitude: dest.longitude,
        );
      }
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

  void _navigateToRideEstimates(BuildContext context, PickAddressState state) {
    final pickupPlace = state.pickupPlace;
    final destinations = state.destinations;
    if (pickupPlace == null || destinations.isEmpty) return;
    final destinationPlace = destinations.last;
    if (destinationPlace == null) return;

    context.pop(
      ConfirmedRideFlowResult(
        pickup: MapLatLng(
          latitude: pickupPlace.latitude,
          longitude: pickupPlace.longitude,
        ),
        destination: MapLatLng(
          latitude: destinationPlace.latitude,
          longitude: destinationPlace.longitude,
        ),
        pickupPlace: pickupPlace,
        destinationPlaces: destinations.whereType<PlaceEntity>().toList(),
        estimateResponse: state.rideEstimateResponse!,
        request: state.rideRequest!,
      ),
    );
  }
}
