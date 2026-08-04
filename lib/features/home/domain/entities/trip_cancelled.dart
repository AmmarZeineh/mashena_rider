import 'package:equatable/equatable.dart';

class TripCancelled extends Equatable {
  final int tripId;
  final String? canceledAt;
  final String? cancelledBy;

  const TripCancelled({
    required this.tripId,
    this.canceledAt,
    this.cancelledBy,
  });

  @override
  List<Object?> get props => [tripId, canceledAt, cancelledBy];
}
