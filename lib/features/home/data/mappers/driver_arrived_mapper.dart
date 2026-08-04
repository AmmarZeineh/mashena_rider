import 'package:mashena_rider/features/home/data/models/driver_arrived_payload.dart';
import 'package:mashena_rider/features/home/domain/entities/driver_arrived.dart';

extension DriverArrivedPayloadX on DriverArrivedPayload {
  DriverArrived toEntity() {
    return DriverArrived(
      tripId: tripId,
      arrivedAt: arrivedAt,
      freeWaitTimeSeconds: freeWaitTimeSeconds,
    );
  }
}
