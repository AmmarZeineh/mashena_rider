import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/features/profile/domain/repositories/profile_repository.dart';
import 'package:mashena_rider/features/profile/presentation/cubits/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit(this.repository) : super(const ProfileState.initial());

  Future<void> getProfile(int id) async {
    emit(const ProfileState.loading());
    final result = await repository.getProfile(id);
    result.fold(
      (failure) => emit(ProfileState.error(failure)),
      (profile) => emit(ProfileState.loaded(profile)),
    );
  }
}
