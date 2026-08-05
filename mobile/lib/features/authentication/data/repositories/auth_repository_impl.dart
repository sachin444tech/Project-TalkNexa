import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {

  @override
  Future<AuthUser?> currentUser() async {
    return null;
  }

  @override
  Future<void> logout() async {}

  @override
  Future<AuthUser?> register({
    required String email,
    required String password,
    required String name,
  }) async {
    return null;
  }

  @override
  Future<AuthUser?> signIn({
    required String email,
    required String password,
  }) async {
    return null;
  }
}