import 'package:equatable/equatable.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/moderation/domain/entities/moderation_overview_entity.dart';

enum ModerationOverviewStatus { initial, loading, success, failure }

class ModerationOverviewState extends Equatable {
  final ModerationOverviewStatus status;
  final ModerationOverviewEntity? overview;
  final Failure? failure;
  final String? realTimeNoticeMessage;

  const ModerationOverviewState({
    this.status = ModerationOverviewStatus.initial,
    this.overview,
    this.failure,
    this.realTimeNoticeMessage,
  });

  ModerationOverviewState copyWith({
    ModerationOverviewStatus? status,
    ModerationOverviewEntity? overview,
    Failure? failure,
    String? realTimeNoticeMessage,
    bool clearRealTimeNotice = false,
  }) {
    return ModerationOverviewState(
      status: status ?? this.status,
      overview: overview ?? this.overview,
      failure: failure,
      realTimeNoticeMessage: clearRealTimeNotice
          ? null
          : (realTimeNoticeMessage ?? this.realTimeNoticeMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    overview,
    failure,
    realTimeNoticeMessage,
  ];
}
