import 'package:mashena_rider/core/constants/app_backend_endpoints.dart';
import 'package:mashena_rider/core/network/api_client.dart';
import '../models/active_trip_context_model.dart';

abstract interface class ActiveTripsRemoteDataSource {
  /// Calls backend endpoint to retrieve active trip contexts.
  Future<List<ActiveTripContextModel>> getActiveTrips();
}

class ActiveTripsRemoteDataSourceImpl implements ActiveTripsRemoteDataSource {
  final ApiClient _api;

  const ActiveTripsRemoteDataSourceImpl(this._api);

  @override
  Future<List<ActiveTripContextModel>> getActiveTrips() async {
    final response = await _api.get(BackendEndpoints.activeContexts);

    List<dynamic> list;
    if (response is List) {
      list = response;
    } else if (response is Map<String, dynamic>) {
      if (response['contexts'] is List) {
        list = response['contexts'] as List;
      } else if (response['data'] is Map<String, dynamic> &&
          (response['data'] as Map<String, dynamic>)['contexts'] is List) {
        list = (response['data'] as Map<String, dynamic>)['contexts'] as List;
      } else if (response['data'] is List) {
        list = response['data'] as List;
      } else {
        list = const [];
      }
    } else if (response is Map) {
      if (response['contexts'] is List) {
        list = response['contexts'] as List;
      } else if (response['data'] is List) {
        list = response['data'] as List;
      } else {
        list = const [];
      }
    } else {
      list = const [];
    }

    return list
        .whereType<Map>()
        .map(
          (json) => ActiveTripContextModel.fromJson(
            Map<String, dynamic>.from(json),
          ),
        )
        .toList();
  }
}
