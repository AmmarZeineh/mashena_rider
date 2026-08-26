import 'package:mashena_rider/core/constants/app_backend_endpoints.dart';
import 'package:mashena_rider/core/network/api_client.dart';
import '../../domain/entities/create_pool_params.dart';
import '../../domain/entities/join_pool_params.dart';
import '../../domain/entities/pool_suggestion_params.dart';
import '../models/pool_room_model.dart';

abstract interface class PoolRemoteDataSource {
  Future<List<PoolRoomModel>> getSuggestions(PoolSuggestionParams params);
  Future<PoolRoomModel> createPoolRoom(CreatePoolParams params);
  Future<PoolRoomModel> getPoolRoomDetails(int roomId);
  Future<PoolRoomModel> joinPoolRoom(int roomId, JoinPoolParams params);
  Future<PoolRoomModel> leavePoolRoom(int roomId);
  Future<PoolRoomModel> cancelPoolRoom(int roomId);
}

class PoolRemoteDataSourceImpl implements PoolRemoteDataSource {
  final ApiClient _api;

  const PoolRemoteDataSourceImpl(this._api);

  @override
  Future<List<PoolRoomModel>> getSuggestions(
    PoolSuggestionParams params,
  ) async {
    final response = await _api.get(
      BackendEndpoints.poolSuggestions,
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
        .map((json) => PoolRoomModel.fromJson(json))
        .toList();
  }

  @override
  Future<PoolRoomModel> createPoolRoom(CreatePoolParams params) async {
    final response = await _api.post(
      BackendEndpoints.createPoolRoom,
      body: params.toJson(),
    );

    return _parsePoolRoomResponse(response, 'create pool room');
  }

  @override
  Future<PoolRoomModel> getPoolRoomDetails(int roomId) async {
    final response = await _api.get(
      BackendEndpoints.getPoolRoomDetails(roomId),
    );
    return _parsePoolRoomResponse(response, 'get pool room details');
  }

  @override
  Future<PoolRoomModel> joinPoolRoom(int roomId, JoinPoolParams params) async {
    final response = await _api.post(
      BackendEndpoints.joinPoolRoom(roomId),
      body: params.toJson(),
    );
    return _parsePoolRoomResponse(response, 'join pool room');
  }

  @override
  Future<PoolRoomModel> leavePoolRoom(int roomId) async {
    final response = await _api.post(BackendEndpoints.leavePoolRoom(roomId));
    return _parsePoolRoomResponse(response, 'leave pool room');
  }

  @override
  Future<PoolRoomModel> cancelPoolRoom(int roomId) async {
    final response = await _api.delete(BackendEndpoints.cancelPoolRoom(roomId));
    return _parsePoolRoomResponse(response, 'cancel pool room');
  }

  PoolRoomModel _parsePoolRoomResponse(dynamic response, String context) {
    Map<String, dynamic> json;
    if (response is Map<String, dynamic>) {
      // Check if response has a 'data' field that is a Map
      if (response.containsKey('data') &&
          response['data'] is Map<String, dynamic>) {
        json = response['data'] as Map<String, dynamic>;
      }
      // If 'data' is not a Map or doesn't exist, use the response directly
      // but only if it looks like a pool room object (has expected fields)
      else if (response.containsKey('id') ||
          response.containsKey('creatorRiderProfileId') ||
          response.containsKey('status')) {
        json = response;
      } else {
        // Fallback: try to use response as-is, but log what we got for debugging
        json = response;
      }
    } else if (response is List && response.isNotEmpty) {
      // Handle case where response is a list (take first item)
      if (response.first is Map<String, dynamic>) {
        json = response.first as Map<String, dynamic>;
      } else {
        json = {};
      }
    } else {
      // Handle unexpected response types
      json = {};
      if (response != null) {
        // In a real app, you might want to log this
        // LoggerService.warning('Unexpected response format: $response', name: 'pool.remote');
      }
    }
    return PoolRoomModel.fromJson(json);
  }
}
