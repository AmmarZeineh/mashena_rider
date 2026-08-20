import 'package:mashena_rider/core/constants/app_backend_endpoints.dart';
import 'package:mashena_rider/core/network/api_client.dart';
import '../../domain/entities/join_shared_ride_params.dart';
import '../../domain/entities/search_shared_ride_params.dart';
import '../models/shared_ride_details_response_model.dart';
import '../models/shared_ride_passenger_model.dart';
import '../models/shared_ride_search_result_model.dart';

abstract interface class SharedTripRemoteDataSource {
  /// Searches for open Shared Ride rooms matching the given coordinates and options.
  Future<List<SharedRideSearchResultModel>> searchSharedRides(
    SearchSharedRideParams params,
  );

  /// Retrieves full details of a specific Shared Ride room by ID.
  Future<SharedRideDetailsResponseModel> getSharedRideDetails(int id);

  /// Joins an open Shared Ride room with requested seat count.
  Future<SharedRidePassengerModel> joinSharedRide(JoinSharedRideParams params);

  /// Leaves an open or ready Shared Ride room.
  Future<SharedRideDetailsResponseModel> leaveSharedRide(int roomId);
}

class SharedTripRemoteDataSourceImpl implements SharedTripRemoteDataSource {
  final ApiClient api;

  const SharedTripRemoteDataSourceImpl(this.api);

  @override
  Future<List<SharedRideSearchResultModel>> searchSharedRides(
    SearchSharedRideParams params,
  ) async {
    final response = await api.get(
      BackendEndpoints.searchSharedRides,
      query: params.toQueryMap(),
    );

    List<dynamic> list;
    if (response is List) {
      list = response;
    } else if (response is Map<String, dynamic> && response['data'] is List) {
      list = response['data'] as List;
    } else {
      list = const [];
    }

    return list
        .whereType<Map<String, dynamic>>()
        .map((json) => SharedRideSearchResultModel.fromJson(json))
        .toList();
  }

  @override
  Future<SharedRideDetailsResponseModel> getSharedRideDetails(int id) async {
    final response = await api.get(BackendEndpoints.getSharedRideDetails(id));

    Map<String, dynamic> json;
    if (response is Map<String, dynamic>) {
      if (response['data'] is Map<String, dynamic>) {
        json = response['data'] as Map<String, dynamic>;
      } else {
        json = response;
      }
    } else {
      throw FormatException(
        'Unexpected response format for shared ride details: $response',
      );
    }

    return SharedRideDetailsResponseModel.fromJson(json);
  }

  @override
  Future<SharedRidePassengerModel> joinSharedRide(
    JoinSharedRideParams params,
  ) async {
    final response = await api.post(
      BackendEndpoints.joinSharedRide(params.roomId),
      body: params.toJson(),
    );

    Map<String, dynamic> json;
    if (response is Map<String, dynamic>) {
      if (response['data'] is Map<String, dynamic>) {
        json = response['data'] as Map<String, dynamic>;
      } else {
        json = response;
      }
    } else {
      throw FormatException(
        'Unexpected response format for join shared ride: $response',
      );
    }

    return SharedRidePassengerModel.fromJson(json);
  }

  @override
  Future<SharedRideDetailsResponseModel> leaveSharedRide(int roomId) async {
    final response = await api.post(BackendEndpoints.leaveSharedRide(roomId));

    Map<String, dynamic> json;
    if (response is Map<String, dynamic>) {
      if (response['data'] is Map<String, dynamic>) {
        json = response['data'] as Map<String, dynamic>;
      } else {
        json = response;
      }
    } else {
      throw FormatException(
        'Unexpected response format for leave shared ride: $response',
      );
    }

    return SharedRideDetailsResponseModel.fromJson(json);
  }
}
