import 'package:bloc_app_demo/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User?> login(String email, String password);

  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String address,
  });

  Future<void> logout();

  Future<User?> getUserProfile();

  Stream<User?> get authStateChanges;
}