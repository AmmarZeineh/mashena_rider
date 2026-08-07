import 'package:equatable/equatable.dart';

/// Entity representing a rider's shared live trip details.
class TripShare extends Equatable {
  final int shareId;
  final String shareUrl;
  final String status;
  final String? expiresAt;

  const TripShare({
    required this.shareId,
    required this.shareUrl,
    required this.status,
    this.expiresAt,
  });

  @override
  List<Object?> get props => [shareId, shareUrl, status, expiresAt];
}
