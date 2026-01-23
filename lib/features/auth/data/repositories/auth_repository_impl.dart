import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
class AuthRepositoryImpl
    implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);
}
