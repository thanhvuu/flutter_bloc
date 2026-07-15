import 'package:fpdart/fpdart.dart';
import 'package:bloc_app_demo/core/errors/failures.dart';
import 'package:bloc_app_demo/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure,User>> login(String email, String password);

  Future<Either<Failure,User>> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String address,
  });

  Future<Either<Failure,void>> logout();

  Future<Either<Failure,User>> getUserProfile();

  Stream<User?> get authStateChanges;

  Future<Either<Failure, User>> signInWithGoogle();


}