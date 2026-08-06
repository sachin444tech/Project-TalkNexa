import 'package:mobile/features/authentication/data/models/auth_user_model.dart';
import 'package:mobile/features/authentication/data/services/firebase_auth_service.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService service = FirebaseAuthService();
  
   @override
Future<AuthUser?> currentUser() async {
  final user = service.currentUser;

  if (user == null) {
    return null;
  }

  return AuthUserModel.fromFirebase(
    user.uid,
    user.displayName,
    user.email!,
    user.photoURL,
  );
}

  @override
Future<void> logout() async {
  await service.logout();
}

  @override
Future<AuthUser?> register({
  required String email,
  required String password,
  required String name,
}) async {
  final credential = await service.register(
    email: email,
    password: password,
  );

  final user = credential.user;

  if (user == null) {
    return null;
  }

  // Save the user's display name in Firebase Authentication
  await user.updateDisplayName(name);

  // Reload the user so the updated display name is available
  await user.reload();

  final updatedUser = service.currentUser!;

  return AuthUserModel.fromFirebase(
    updatedUser.uid,
    updatedUser.displayName,
    updatedUser.email!,
    updatedUser.photoURL,
  );
}

 @override
Future<AuthUser?> signIn({
  required String email,
  required String password,
}) async {
  final credential = await service.signIn(
    email: email,
    password: password,
  );

  final user = credential.user;

  if (user == null) {
    return null;
  }

  return AuthUserModel.fromFirebase(
    user.uid,
    user.displayName,
    user.email!,
    user.photoURL,
  );
 }
}