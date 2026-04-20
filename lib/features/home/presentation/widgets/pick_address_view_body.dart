import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/widgets/custom_header_button.dart';
import 'package:mashena_rider/features/home/presentation/cubits/pick_address_cubit/pick_address_cubit.dart';
import 'package:mashena_rider/features/home/presentation/cubits/pick_address_cubit/pick_address_state.dart';
import 'package:mashena_rider/features/home/presentation/widgets/custom_divider.dart';
import 'package:mashena_rider/features/home/presentation/widgets/pick_location_circular_container.dart';
import 'package:mashena_rider/features/home/presentation/widgets/recent_address_tile_widget.dart';
import 'package:mashena_rider/features/home/presentation/widgets/saved_place_widget.dart';

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

  void _syncControllers(PickAddressState state) {
    // Sync pickup text
    if (state.pickupPlace != null &&
        _pickupController.text != state.pickupPlace!.name) {
      _pickupController.value = TextEditingValue(
        text: state.pickupPlace!.name,
        selection: TextSelection.collapsed(
          offset: state.pickupPlace!.name.length,
        ),
      );
    } else if (state.pickupPlace == null &&
        _pickupController.text.isNotEmpty &&
        state.searchQuery.isEmpty) {
      // Clear if completely reset
      // We check searchQuery isEmpty so we don't clear while the user is typing to search
      _pickupController.clear();
    }

    // Expand controller list if needed
    while (_destControllers.length < state.destinations.length) {
      _destControllers.add(TextEditingController());
    }
    // Shrink if needed
    while (_destControllers.length > state.destinations.length) {
      _destControllers.removeLast().dispose();
    }

    // Sync destination texts
    for (int i = 0; i < state.destinations.length; i++) {
      final place = state.destinations[i];
      if (place != null && _destControllers[i].text != place.name) {
        _destControllers[i].value = TextEditingValue(
          text: place.name,
          selection: TextSelection.collapsed(offset: place.name.length),
        );
      }
    }
  }

  Future<void> _openMapPicker(BuildContext context, int fieldIndex) async {
    final cubit = context.read<PickAddressCubit>();
    cubit.setActiveField(fieldIndex);

    // Default to a central location if no place is selected
    const defaultLoc = MapLatLng(latitude: 33.5153, longitude: 36.2772);
    MapLatLng initialLoc = defaultLoc;

    if (fieldIndex == 0 && cubit.state.pickupPlace != null) {
      initialLoc = MapLatLng(
        latitude: cubit.state.pickupPlace!.latitude,
        longitude: cubit.state.pickupPlace!.longitude,
      );
    } else if (fieldIndex > 0) {
      final destIndex = fieldIndex - 1;
      if (cubit.state.destinations[destIndex] != null) {
        initialLoc = MapLatLng(
          latitude: cubit.state.destinations[destIndex]!.latitude,
          longitude: cubit.state.destinations[destIndex]!.longitude,
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PickAddressCubit, PickAddressState>(
      listener: (context, state) {
        _syncControllers(state);

        if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }

        // Pop with the estimate response so the caller (HomeView) can show
        // the CarTypeBottomSheet.
        if (!state.isCreatingRideRequest &&
            state.rideEstimateResponse != null) {
          context.pop(state.rideEstimateResponse);
        }
      },
      builder: (context, state) {
        final cubit = context.read<PickAddressCubit>();
        if (_destControllers.isEmpty) {
          _syncControllers(state); // Initial sync
        }

        return Scaffold(
          body: ModalProgressHUD(
            inAsyncCall: state.isCreatingRideRequest,
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  /// Top Section (Inputs)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomHeaderButton(),
                        const SizedBox(height: 16),

                        // Pickup Field
                        Row(
                          children: [
                            PickLocationCircularContainer(
                              isActive: state.pickupPlace != null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Focus(
                                onFocusChange: (hasFocus) {
                                  if (hasFocus) cubit.setActiveField(0);
                                },
                                child: TextField(
                                  controller: _pickupController,
                                  onChanged: (value) => cubit.onSearchChanged(
                                    value,
                                    language: WidgetsBinding
                                        .instance
                                        .platformDispatcher
                                        .locale
                                        .languageCode,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: S.of(context).homeCurrentLocation,
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
                            IconButton(
                              icon: const Icon(Icons.map),
                              onPressed: () => _openMapPicker(context, 0),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Destinations
                        ...state.destinations.asMap().entries.map((entry) {
                          final index = entry.key;
                          final fieldIndex = index + 1;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                PickLocationCircularContainer(
                                  isActive: state.destinations[index] != null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Focus(
                                    onFocusChange: (hasFocus) {
                                      if (hasFocus) {
                                        cubit.setActiveField(fieldIndex);
                                      }
                                    },
                                    child: TextField(
                                      controller: _destControllers[index],
                                      onChanged: (value) =>
                                          cubit.onSearchChanged(
                                            value,
                                            language: WidgetsBinding
                                                .instance
                                                .platformDispatcher
                                                .locale
                                                .languageCode,
                                          ),
                                      decoration: InputDecoration(
                                        hintText: S
                                            .of(context)
                                            .enterDestination,
                                        filled: true,
                                        fillColor: Theme.of(
                                          context,
                                        ).colorScheme.surfaceContainerHighest,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            28,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.map),
                                  onPressed: () =>
                                      _openMapPicker(context, fieldIndex),
                                ),
                                if (state.destinations.length > 1)
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () =>
                                        cubit.removeDestination(index),
                                  ),
                              ],
                            ),
                          );
                        }),

                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: cubit.addDestination,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          S.of(context).homeNowYouCanAddMultipleStops,
                          style: AppTextStyles.w400_12.copyWith(
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Confirm ride button
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: state.isReadyToConfirm
                                ? () => cubit.confirmRide()
                                : null,
                            icon: const Icon(Icons.check_circle_outline),
                            label: Text(S.of(context).commonConfirm),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  const CustomDivider(),
                  const SizedBox(height: 16),

                  /// Results or Saved/Recent
                  if (state.searchQuery.isNotEmpty) ...[
                    if (state.isSearching)
                      const Center(child: CircularProgressIndicator())
                    else if (state.searchResults.isNotEmpty)
                      ...state.searchResults.map(
                        (place) => ListTile(
                          leading: const Icon(Icons.location_on_outlined),
                          title: Text(place.name),
                          subtitle: Text(place.address),
                          onTap: () {
                            cubit.selectPlace(place);
                            // Unfocus keyboard
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      )
                    else
                      const Center(child: Text("No results found")),
                  ] else if (state.activeFieldIndex == 0 &&
                      state.pickupPlace == null) ...[
                    ListTile(
                      leading: const Icon(Icons.my_location),
                      title: Text(S.of(context).homeCurrentLocation),
                      onTap: () {
                        cubit.useDeviceLocation(
                          language: WidgetsBinding
                              .instance
                              .platformDispatcher
                              .locale
                              .languageCode,
                        );
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ] else ...[
                    // Default saved places
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: const [
                          SavedPlaceTile(
                            title: "Home",
                            subtitle:
                                "Neemuch RD. Gopalbari, Bari Sadri Rajasthan",
                          ),
                          SizedBox(height: 16),
                          SavedPlaceTile(
                            title: "Work",
                            subtitle: "Jawahar Lal Nehru Marg, D-Block",
                          ),
                          SizedBox(height: 24),
                          RecentTile("250 west, industrial area"),
                          RecentTile("4 number gali pratap nagar"),
                          RecentTile("Neemuch RD. Gopalbari, Bari Sad"),
                          RecentTile("Jawahar Lal Nehru Marg, D-Block"),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
