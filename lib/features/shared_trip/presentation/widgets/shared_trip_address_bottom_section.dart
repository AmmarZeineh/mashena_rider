import 'package:flutter/material.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/features/home/presentation/address/widgets/saved_places_section.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/pick_shared_trip_address_cubit/pick_shared_trip_address_cubit.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/pick_shared_trip_address_cubit/pick_shared_trip_address_state.dart';

class SharedTripAddressBottomSection extends StatelessWidget {
  const SharedTripAddressBottomSection({
    super.key,
    required this.state,
    required this.cubit,
  });

  final PickSharedTripAddressState state;
  final PickSharedTripAddressCubit cubit;

  @override
  Widget build(BuildContext context) {
    if (state.searchQuery.isNotEmpty) {
      if (state.isSearching) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (state.searchResults.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text("No results found"),
          ),
        );
      }

      return Column(
        children: state.searchResults
            .map(
              (place) => ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: Text(place.name),
                onTap: () {
                  cubit.selectPlace(place);
                  FocusScope.of(context).unfocus();
                },
              ),
            )
            .toList(),
      );
    }

    if (state.activeFieldIndex == 0 && state.pickupPlace == null) {
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

    return const SavedPlacesSection();
  }
}
