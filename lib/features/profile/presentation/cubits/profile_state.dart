import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/profile/domain/entities/rider_profile.dart';

part 'profile_state.freezed.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _Initial;
  const factory ProfileState.loading() = _Loading;
  const factory ProfileState.loaded(RiderProfile profile) = _Loaded;
  const factory ProfileState.error(Failure failure) = _Error;
}
