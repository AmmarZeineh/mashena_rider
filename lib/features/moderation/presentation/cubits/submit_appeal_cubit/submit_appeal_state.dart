import 'package:equatable/equatable.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/moderation/domain/entities/appeal_entity.dart';

enum SubmitAppealStatus { initial, submitting, success, failure }

class SubmitAppealState extends Equatable {
  final SubmitAppealStatus status;
  final AppealEntity? submittedAppeal;
  final Failure? failure;
  final String? validationError;

  const SubmitAppealState({
    this.status = SubmitAppealStatus.initial,
    this.submittedAppeal,
    this.failure,
    this.validationError,
  });

  SubmitAppealState copyWith({
    SubmitAppealStatus? status,
    AppealEntity? submittedAppeal,
    Failure? failure,
    String? validationError,
    bool clearValidationError = false,
  }) {
    return SubmitAppealState(
      status: status ?? this.status,
      submittedAppeal: submittedAppeal ?? this.submittedAppeal,
      failure: failure,
      validationError: clearValidationError
          ? null
          : (validationError ?? this.validationError),
    );
  }

  @override
  List<Object?> get props => [
    status,
    submittedAppeal,
    failure,
    validationError,
  ];
}
