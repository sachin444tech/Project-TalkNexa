enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthState {
  final AuthStatus status;
  final String? message;

  const AuthState({
    required this.status,
    this.message,
  });

  factory AuthState.initial() =>
      const AuthState(status: AuthStatus.initial);

  factory AuthState.loading() =>
      const AuthState(status: AuthStatus.loading);

  factory AuthState.authenticated() =>
      const AuthState(status: AuthStatus.authenticated);

  factory AuthState.unauthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);

  factory AuthState.error(String message) =>
      AuthState(
        status: AuthStatus.error,
        message: message,
      );
}