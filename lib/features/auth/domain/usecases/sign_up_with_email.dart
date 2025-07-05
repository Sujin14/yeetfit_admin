import '../../domain/repositories/auth_repository.dart';

class SignUpWithEmail {
  final AuthRepository repository;

  SignUpWithEmail(this.repository);

  Future<bool> call(String email, String password, String name) async {
    final userCredential = await repository.signUpWithEmail(
      email,
      password,
      name,
    );
    return userCredential != null;
  }
}
