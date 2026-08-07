part of 'trip_share_cubit.dart';

sealed class TripShareState extends Equatable {
  const TripShareState();

  @override
  List<Object?> get props => [];
}

class TripShareInitial extends TripShareState {
  const TripShareInitial();
}

class TripShareLoading extends TripShareState {
  const TripShareLoading();
}

class TripShareLoaded extends TripShareState {
  final TripShare tripShare;

  const TripShareLoaded(this.tripShare);

  @override
  List<Object?> get props => [tripShare];
}

class TripShareRevoking extends TripShareState {
  final TripShare tripShare;

  const TripShareRevoking(this.tripShare);

  @override
  List<Object?> get props => [tripShare];
}

class TripShareError extends TripShareState {
  final String message;

  const TripShareError(this.message);

  @override
  List<Object?> get props => [message];
}
