import '../../domain/repositories/auth_repository.dart';

class LoginWithEmail {
  final AuthRepository repository;

  LoginWithEmail(this.repository);

  Future<bool> call(String email, String password) async {
    final userCredential = await repository.signInWithEmail(email, password);
    if (userCredential == null) return false;
    return await repository.isAdmin(userCredential.user!.uid);
  }
}
