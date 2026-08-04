part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];

  @override
  bool get stringify => true;
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final AuthSession session;

  const LoginSuccess(this.session);

  @override
  List<Object?> get props => [session];
}

final class LoginFailure extends LoginState {
  const LoginFailure(this.failure);
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
