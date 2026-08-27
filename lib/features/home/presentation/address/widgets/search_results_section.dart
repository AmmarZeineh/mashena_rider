import 'package:flutter/material.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/features/home/presentation/address/cubits/pick_address_cubit/pick_address_cubit.dart';
import 'package:mashena_rider/features/home/presentation/address/cubits/pick_address_cubit/pick_address_state.dart';

class SearchResultsSection extends StatelessWidget {
  const SearchResultsSection({
    super.key,
    required this.state,
    required this.cubit,
  });

  final PickAddressState state;
  final PickAddressCubit cubit;

  @override
  Widget build(BuildContext context) {
    if (state.isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.searchResults.isEmpty) {
      return Center(child: Text(S.of(context).commonNoResultsFound));
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
}
