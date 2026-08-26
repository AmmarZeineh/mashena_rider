import 'dart:async';
import 'package:mashena_rider/core/network/socket_client.dart';
import 'package:mashena_rider/core/services/logger_service.dart';

abstract interface class ModerationSocketDataSource {
  Stream<Map<String, dynamic>> get penaltyIssuedStream;
  Stream<Map<String, dynamic>> get restrictionLiftedStream;
  Future<void> connectSocket();
  Future<void> dispose();
}

class ModerationSocketDataSourceImpl implements ModerationSocketDataSource {
  final SocketClient _socketClient;

  final StreamController<Map<String, dynamic>> _penaltyIssuedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _restrictionLiftedController =
      StreamController<Map<String, dynamic>>.broadcast();

  late final void Function(dynamic) _onPenaltyIssued;
  late final void Function(dynamic) _onRestrictionLifted;

  ModerationSocketDataSourceImpl(this._socketClient) {
    _initSocketListeners();
  }

  void _initSocketListeners() {
    _onPenaltyIssued = (data) {
      LoggerService.info(
        'Received moderation:penalty_issued event: $data',
        name: 'features.moderation.socket',
      );
      try {
        if (data is Map && !_penaltyIssuedController.isClosed) {
          _penaltyIssuedController.add(Map<String, dynamic>.from(data));
        }
      } catch (e, stackTrace) {
        LoggerService.error(
          'Error handling moderation:penalty_issued socket event',
          name: 'features.moderation.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('moderation:penalty_issued', _onPenaltyIssued);

    _onRestrictionLifted = (data) {
      LoggerService.info(
        'Received moderation:restriction_lifted event: $data',
        name: 'features.moderation.socket',
      );
      try {
        if (data is Map && !_restrictionLiftedController.isClosed) {
          _restrictionLiftedController.add(Map<String, dynamic>.from(data));
        }
      } catch (e, stackTrace) {
        LoggerService.error(
          'Error handling moderation:restriction_lifted socket event',
          name: 'features.moderation.socket',
          error: e,
          stackTrace: stackTrace,
        );
      }
    };
    _socketClient.on('moderation:restriction_lifted', _onRestrictionLifted);
  }

  @override
  Stream<Map<String, dynamic>> get penaltyIssuedStream =>
      _penaltyIssuedController.stream;

  @override
  Stream<Map<String, dynamic>> get restrictionLiftedStream =>
      _restrictionLiftedController.stream;

  @override
  Future<void> connectSocket() => _socketClient.connect();

  @override
  Future<void> dispose() async {
    _socketClient.off('moderation:penalty_issued', _onPenaltyIssued);
    _socketClient.off('moderation:restriction_lifted', _onRestrictionLifted);

    if (!_penaltyIssuedController.isClosed) {
      await _penaltyIssuedController.close();
    }
    if (!_restrictionLiftedController.isClosed) {
      await _restrictionLiftedController.close();
    }
  }
}
