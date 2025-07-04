import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/email_auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final EmailAuthService emailService;

  AuthRepositoryImpl({required this.emailService});

  @override
  Future<UserCredential?> signInWithEmail(String email, String password) {
    return emailService.signInWithEmail(email, password);
  }

  @override
  Future<UserCredential?> signUpWithEmail(
    String email,
    String password,
    String name,
  ) {
    return emailService.signUpWithEmail(email, password, name);
  }

  @override
  Future<bool> isAdmin(String uid) {
    return emailService.isAdmin(uid);
  }
}
