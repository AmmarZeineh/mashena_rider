import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mashena_rider/features/home/domain/entities/place_entity.dart';

part 'pick_address_state.freezed.dart';

@freezed
class PickAddressState with _$PickAddressState {
  const factory PickAddressState({
    PlaceEntity? pickupPlace,
    @Default([null]) List<PlaceEntity?> destinations,
    @Default(0) int activeFieldIndex, // 0 = pickup, 1 = dest[0], 2 = dest[1]...
    @Default('') String searchQuery,
    @Default([]) List<PlaceEntity> searchResults,
    @Default(false) bool isSearching,
    @Default(false) bool isReversingGeocode,
    @Default(false) bool isCreatingRideRequest,
    String? errorMessage,
  }) = _PickAddressState;

  factory PickAddressState.initial() => const PickAddressState();
}
