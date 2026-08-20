import 'package:equatable/equatable.dart';

class DriverArrived extends Equatable {
  final int tripId;
  final String? arrivedAt;
  final int freeWaitTimeSeconds;

  const DriverArrived({
    required this.tripId,
    this.arrivedAt,
    this.freeWaitTimeSeconds = 300,
  });

  @override
  List<Object?> get props => [tripId, arrivedAt, freeWaitTimeSeconds];
}
