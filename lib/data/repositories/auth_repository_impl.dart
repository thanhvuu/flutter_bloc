import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloc_app_demo/domain/entities/user.dart';
import 'package:bloc_app_demo/domain/repositories/auth_repository.dart';
import 'package:bloc_app_demo/data/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Future<User?> _mapFirebaseUserToEntity(firebase_auth.User? firebaseUser) async {
    if(firebaseUser == null) return null;

    final doc = await _firestore.collection('user').doc(firebaseUser.uid).get();

    if(doc.exists) {
      // Gắn thêm id vào Map data vì Firebase thường không lưu id ở trong document field
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
  Future<User?> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return await _mapFirebaseUserToEntity(credential.user);
    } catch (e) {
      rethrow;
    }
  }

  @override  
  Future<User?> signUp({
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

      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override  
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override  
  Future<User?> getUserProfile() async {
    final firebaseUser = _firebaseAuth.currentUser;
    return await _mapFirebaseUserToEntity(firebaseUser);
  }

  @override  
  Stream<User?> get authStateChanges {
    return  _firebaseAuth.authStateChanges().asyncMap(_mapFirebaseUserToEntity);
  }
}