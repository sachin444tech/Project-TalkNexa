import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  AuthUser? getCurrentUser();
}
