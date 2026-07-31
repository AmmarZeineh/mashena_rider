import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/home/domain/entities/place_entity.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate_response.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_request.dart';

part 'pick_address_state.freezed.dart';

@freezed
abstract class PickAddressState with _$PickAddressState {
  const factory PickAddressState({
    PlaceEntity? pickupPlace,
    @Default([null]) List<PlaceEntity?> destinations,
    @Default(0) int activeFieldIndex,
    @Default('') String searchQuery,
    @Default([]) List<PlaceEntity> searchResults,
    @Default(false) bool isSearching,
    @Default(false) bool isReversingGeocode,
    @Default(false) bool isCreatingRideRequest,
    RideEstimateResponse? rideEstimateResponse,
    RideRequest? rideRequest,
    RideEstimate? selectedRideEstimate,
    Failure? errorMessage,
    String? warningMessage,
  }) = _PickAddressState;

  factory PickAddressState.initial() => const PickAddressState();
}

extension PickAddressStateX on PickAddressState {
  /// Whether all location fields are filled and the user
  /// can confirm the ride request.
  bool get isReadyToConfirm =>
      pickupPlace != null &&
      destinations.isNotEmpty &&
      destinations.every((d) => d != null);
}
