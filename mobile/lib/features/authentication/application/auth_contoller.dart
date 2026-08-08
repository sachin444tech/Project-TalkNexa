import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/utils/auth_error_mapper.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

class AuthController extends Notifier<AuthState> {
  late final AuthRepository _repository;

  @override
  AuthState build() {
    _repository = ref.read(authRepositoryProvider);

    final currentUser = _repository.getCurrentUser();

    if (currentUser != null) {
      return const AuthState(
        status: AuthStatus.authenticated,
      );
    }

    return const AuthState(
      status: AuthStatus.unauthenticated,
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AuthState(
      status: AuthStatus.loading,
    );

    try {
      final user =
          await _repository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (user == null) {
        state = const AuthState(
          status: AuthStatus.error,
          errorMessage: 'Unable to sign in.',
        );

        return;
      }

      state = const AuthState(
        status: AuthStatus.authenticated,
      );
    } on FirebaseAuthException catch (exception) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: AuthErrorMapper.map(exception),
      );
    } catch (_) {
      state = const AuthState(
        status: AuthStatus.error,
        errorMessage:
            'Something went wrong. Please try again.',
      );
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();

    state = const AuthState(
      status: AuthStatus.unauthenticated,
    );
  }
}
