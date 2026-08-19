import '../../domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.name,
    required super.email,
    super.photoUrl,
  });

  factory AuthUserModel.fromFirebase(
    String id,
    String? name,
    String email,
    String? photoUrl,
  ) {
    return AuthUserModel(
      id: id,
      name: name ?? "",
      email: email,
      photoUrl: photoUrl,
    );
  }
}
