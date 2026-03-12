import 'package:dartz/dartz.dart';
import '../entities/ride_request.dart';

abstract interface class RideRepository {
  Future<Either<String, dynamic>> createRideRequest(RideRequest request);
}
