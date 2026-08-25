import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../services/firebase_auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService _authService;

  AuthRepositoryImpl({FirebaseAuthService? authService})
    : _authService = authService ?? FirebaseAuthService();

  @override
  Future<AuthUser?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _authService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      return null;
    }

    return AuthUser(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
    );
  }

  @override
  Future<void> signOut() {
    return _authService.signOut();
  }

  @override
  AuthUser? getCurrentUser() {
    final user = _authService.getCurrentUser();

    if (user == null) {
      return null;
    }

    return AuthUser(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
    );
  }
}
