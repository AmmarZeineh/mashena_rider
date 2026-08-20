import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/home/domain/entities/place_entity.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate_response.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_request.dart';

class PickSharedTripAddressState {
  const PickSharedTripAddressState({
    this.pickupPlace,
    this.destinationPlace,
    this.activeFieldIndex = 0,
    this.searchQuery = '',
    this.searchResults = const [],
    this.isSearching = false,
    this.isReversingGeocode = false,
    this.isCreatingRideRequest = false,
    this.rideEstimateResponse,
    this.rideRequest,
    this.selectedRideEstimate,
    this.errorMessage,
    this.warningMessage,
  });

  final PlaceEntity? pickupPlace;
  final PlaceEntity? destinationPlace;
  final int activeFieldIndex;
  final String searchQuery;
  final List<PlaceEntity> searchResults;
  final bool isSearching;
  final bool isReversingGeocode;
  final bool isCreatingRideRequest;
  final RideEstimateResponse? rideEstimateResponse;
  final RideRequest? rideRequest;
  final RideEstimate? selectedRideEstimate;
  final Failure? errorMessage;
  final String? warningMessage;

  factory PickSharedTripAddressState.initial() =>
      const PickSharedTripAddressState();

  bool get isReadyToConfirm =>
      pickupPlace != null && destinationPlace != null && warningMessage == null;

  PickSharedTripAddressState copyWith({
    PlaceEntity? Function()? pickupPlace,
    PlaceEntity? Function()? destinationPlace,
    int? activeFieldIndex,
    String? searchQuery,
    List<PlaceEntity>? searchResults,
    bool? isSearching,
    bool? isReversingGeocode,
    bool? isCreatingRideRequest,
    RideEstimateResponse? Function()? rideEstimateResponse,
    RideRequest? Function()? rideRequest,
    RideEstimate? Function()? selectedRideEstimate,
    Failure? Function()? errorMessage,
    String? Function()? warningMessage,
  }) {
    return PickSharedTripAddressState(
      pickupPlace: pickupPlace != null ? pickupPlace() : this.pickupPlace,
      destinationPlace: destinationPlace != null
          ? destinationPlace()
          : this.destinationPlace,
      activeFieldIndex: activeFieldIndex ?? this.activeFieldIndex,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      isReversingGeocode: isReversingGeocode ?? this.isReversingGeocode,
      isCreatingRideRequest:
          isCreatingRideRequest ?? this.isCreatingRideRequest,
      rideEstimateResponse: rideEstimateResponse != null
          ? rideEstimateResponse()
          : this.rideEstimateResponse,
      rideRequest: rideRequest != null ? rideRequest() : this.rideRequest,
      selectedRideEstimate: selectedRideEstimate != null
          ? selectedRideEstimate()
          : this.selectedRideEstimate,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      warningMessage: warningMessage != null
          ? warningMessage()
          : this.warningMessage,
    );
  }
}
