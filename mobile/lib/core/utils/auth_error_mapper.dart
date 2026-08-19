import 'package:firebase_auth/firebase_auth.dart';

class AuthErrorMapper {
  static String map(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-credential':
        return 'Incorrect email or password.';

      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'user-disabled':
        return 'This account has been disabled.';

      case 'user-not-found':
        return 'No account was found with this email.';

      case 'wrong-password':
        return 'Incorrect password.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'network-request-failed':
        return 'Please check your internet connection.';

      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
