import 'package:equatable/equatable.dart';
import 'package:mashena_rider/features/home/domain/entities/place_entity.dart';

class PickAddressState extends Equatable {
  final PlaceEntity? pickupPlace;
  final List<PlaceEntity?> destinations;
  final int activeFieldIndex; // 0 = pickup, 1 = dest[0], 2 = dest[1]...
  final String searchQuery;
  final List<PlaceEntity> searchResults;
  final bool isSearching;
  final bool isReversingGeocode;

  const PickAddressState({
    this.pickupPlace,
    required this.destinations,
    this.activeFieldIndex = 0,
    this.searchQuery = '',
    this.searchResults = const [],
    this.isSearching = false,
    this.isReversingGeocode = false,
  });

  factory PickAddressState.initial() {
    return const PickAddressState(
      destinations: [null], // One empty destination by default
    );
  }

  PickAddressState copyWith({
    PlaceEntity? pickupPlace,
    List<PlaceEntity?>? destinations,
    int? activeFieldIndex,
    String? searchQuery,
    List<PlaceEntity>? searchResults,
    bool? isSearching,
    bool? isReversingGeocode,
  }) {
    return PickAddressState(
      pickupPlace: pickupPlace ?? this.pickupPlace,
      destinations: destinations ?? this.destinations,
      activeFieldIndex: activeFieldIndex ?? this.activeFieldIndex,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      isReversingGeocode: isReversingGeocode ?? this.isReversingGeocode,
    );
  }

  @override
  List<Object?> get props => [
        pickupPlace,
        destinations,
        activeFieldIndex,
        searchQuery,
        searchResults,
        isSearching,
        isReversingGeocode,
      ];
}
