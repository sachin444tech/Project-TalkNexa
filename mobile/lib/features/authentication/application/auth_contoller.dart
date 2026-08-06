import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(AuthState.initial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = AuthState.loading();

    await Future.delayed(
      const Duration(seconds: 2),
    );

    state = AuthState.authenticated();
  }

  Future<void> logout() async {
    state = AuthState.unauthenticated();
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(),
);