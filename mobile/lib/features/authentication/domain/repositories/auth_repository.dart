import '../entities/auth_user.dart';

abstract class AuthRepository {

  Future<AuthUser?> signIn({
    required String email,
    required String password,
  });

  Future<AuthUser?> register({
    required String email,
    required String password,
    required String name,
  });

  Future<void> logout();

  Future<AuthUser?> currentUser();

}