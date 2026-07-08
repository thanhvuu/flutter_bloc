import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_app_demo/domain/entities/user.dart';
import 'package:bloc_app_demo/domain/repositories/auth_repository.dart';



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

    final result = await _authRepository.login(event.email, event.password);

    result.fold(
      (failure) {
        emit(AuthError(failure.message));
        emit(Unauthenticated());
      },
      (user) {
        emit(Authenticated(user));
      },
    );
  }

  Future<void> _onSignUpRequested(SignUpRequestedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

      final result = await _authRepository.signUp(
        email: event.email,
        password: event.password,
        name: event.name,
        phone: event.phone,
        address: event.address,
      );

       result.fold(
        (failure) {
          emit(AuthError(failure.message));
          emit(Unauthenticated());
        },
        (user) {
          emit(Authenticated(user));
        }
      );
     
  }

  Future<void> _onLogoutRequested(LogoutRequestedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
      final result = await _authRepository.logout();

      result.fold(
        (failure) {
          emit(AuthError(failure.message));
        },
        (_) {

        }
      );
   
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}