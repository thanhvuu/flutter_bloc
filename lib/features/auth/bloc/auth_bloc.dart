import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_app_demo/domain/entities/user.dart';
import 'package:bloc_app_demo/domain/repositories/auth_repository.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<User?>? _authSubscription;

  
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    
   
    on<AuthStatusChangedEvent>(_onAuthStatusChanged);
    on<LoginRequestedEvent>(_onLoginRequested);
    on<SignUpRequestedEvent>(_onSignUpRequested);
    on<LogoutRequestedEvent>(_onLogoutRequested);

    
    _authSubscription = _authRepository.authStateChanges.listen((user) {
      add(AuthStatusChangedEvent(user));
    });
  }

  void _onAuthStatusChanged(AuthStatusChangedEvent event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(Authenticated(event.user!));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoginRequested(LoginRequestedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(event.email, event.password);
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(_parseFirebaseError(e)));
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignUpRequested(SignUpRequestedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signUp(
        email: event.email,
        password: event.password,
        name: event.name,
        phone: event.phone,
        address: event.address,
      );
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(_parseFirebaseError(e)));
      emit(Unauthenticated());
    }
  }

  Future<void> _onLogoutRequested(LogoutRequestedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.logout();
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  String _parseFirebaseError(dynamic error) {
    final errorStr = error.toString();
    if (errorStr.contains('user-not-found') || errorStr.contains('invalid-credential')) {
      return 'Thông tin đăng nhập không chính xác.';
    } else if (errorStr.contains('wrong-password')) {
      return 'Mật khẩu không chính xác.';
    } else if (errorStr.contains('email-already-in-use')) {
      return 'Email này đã được đăng ký bởi tài khoản khác.';
    } else if (errorStr.contains('weak-password')) {
      return 'Mật khẩu quá yếu (tối thiểu phải có 6 ký tự).';
    } else if (errorStr.contains('invalid-email')) {
      return 'Định dạng email không hợp lệ.';
    }
    return 'Lỗi: ${error.toString()}';
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}