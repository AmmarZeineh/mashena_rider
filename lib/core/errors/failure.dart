import 'package:equatable/equatable.dart';

enum FailureCode {
  networkTimeout,
  networkConnection,
  requestCancelled,
  unauthorized,
  forbidden,
  notFound,
  validation,
  server,
  cache,
  tripCancelledByDriver,
  tripCancelledByAdmin,
  tripCancelled,
  rideExpired,
  unknown,
}

final class Failure extends Equatable {
  const Failure(
    this.code, {
    this.statusCode,
    this.args = const [],
    this.rawMessage,
  });

  final FailureCode code;
  final int? statusCode;
  final List<String> args;
  final String? rawMessage;

  @override
  List<Object?> get props => [code, statusCode, args, rawMessage];
}
