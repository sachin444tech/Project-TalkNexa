import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository repository;

  AuthController(this.repository) : super(AuthState.initial());

  Future<void> login({
  required String email,
  required String password,
}) async {
  state = AuthState.loading();

  try {
    final user = await repository.signIn(
      email: email,
      password: password,
    );

    if (user == null) {
      state = AuthState.error("Login failed");
      return;
    }

    state = AuthState.authenticated();
  } catch (e) {
    state = AuthState.error(
      e.toString(),
    );
  }
}

 Future<void> logout() async {
  try {
    await repository.logout();
    state = AuthState.unauthenticated();
  } catch (e) {
    state = AuthState.error(
      e.toString(),
    );
  }
}
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(
    ref.read(authRepositoryProvider),
  ),
);

