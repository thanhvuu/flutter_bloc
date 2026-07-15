import 'package:fpdart/fpdart.dart';
import 'package:bloc_app_demo/core/errors/failures.dart';
import 'package:bloc_app_demo/core/utils/firebase_error_handler.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloc_app_demo/domain/entities/user.dart';
import 'package:bloc_app_demo/domain/repositories/auth_repository.dart';
import 'package:bloc_app_demo/data/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

    Future<User?> _mapFirebaseUserToEntity(firebase_auth.User? firebaseUser) async {
    if(firebaseUser == null) return null;

    DocumentSnapshot<Map<String, dynamic>> doc;

    try{
      doc = await _firestore.collection('user').doc(firebaseUser.uid).get(
        const GetOptions(source: Source.cache),
      );
    } catch (_) {
      doc = await _firestore.collection('user').doc(firebaseUser.uid).get(
        const GetOptions(source: Source.server),
      );
    }

    if(doc.exists) {
      final data = doc.data()!;
      data['id'] = firebaseUser.uid; 
      
      final model = UserModel.fromJson(data);
      return model.toEntity();
    } else {
       final model = UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        name: '',
        phone: '',
        address: '',
      );
      return model.toEntity();
    }
  }



  @override  
  Future<Either<Failure,User>> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final userEntity = await _mapFirebaseUserToEntity(credential.user);
      if(userEntity != null) {
        return Right(userEntity);
      } else {
        return const Left(AuthFailure("Không thể lấy thông tin tài khoản!"));
      }
    } catch (e) {
      final errorMsg = FirebaseErrorHandler.parseError(e);
      return Left(AuthFailure(errorMsg));
    }
  }

  @override  
  Future<Either<Failure,User>> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String address,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      final String uid = credential.user!.uid;

      final model = UserModel(
        id: uid,
        email: email,
        name: name,
        phone: phone,
        address: address,
      );

      await _firestore.collection('user').doc(uid).set(model.toJson());

      return Right(model.toEntity());
    } catch (e) {
      final errorMsg = FirebaseErrorHandler.parseError(e);
      return Left(AuthFailure(errorMsg));
    }
  }

  @override  
  Future<Either<Failure,void>> logout() async {
    try {
    await _firebaseAuth.signOut();
    return const Right(null);

    } catch (e){
      return Left(AuthFailure("Lỗi khi đăng xuất: ${e.toString()}"));
    }
  }

  @override  
  Future<Either<Failure,User>> getUserProfile() async {
    try {
    final firebaseUser = _firebaseAuth.currentUser;
    if(firebaseUser == null){
      return const Left(AuthFailure("Người dùng chưa đăng nhập"));
    }

    final userEntity = await _mapFirebaseUserToEntity(firebaseUser);
    if(userEntity != null) {
      return Right(userEntity);
    } else {
      return const Left(AuthFailure("Không có thông tin tài khoản"));
    } 
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override  
  Stream<User?> get authStateChanges {
    return  _firebaseAuth.authStateChanges().asyncMap(_mapFirebaseUserToEntity);
  }


    @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return const Left(AuthFailure("Đăng nhập Google bị hủy"));
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      
      final authResult = await _firebaseAuth.signInWithCredential(credential);
      final userEntity = await _mapFirebaseUserToEntity(authResult.user);
      
      if (userEntity != null) {
        return Right(userEntity);
      } else {
        return const Left(AuthFailure("Lỗi khi đồng bộ dữ liệu người dùng"));
      }
    } catch (e) {
      return Left(AuthFailure(FirebaseErrorHandler.parseError(e)));
    }
  }
}