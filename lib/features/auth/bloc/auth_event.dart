part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStatusChangedEvent extends AuthEvent {
  final User? user;

  const AuthStatusChangedEvent(this.user);

  @override  
  List<Object?> get props => [user];
}

class LoginRequestedEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginRequestedEvent({required this.email, required this.password});

  @override  
  List<Object?> get props => [email,password];
}

class SignUpRequestedEvent extends AuthEvent {
  final String email;
  final String password;
  final String phone;
  final String address;
  final String name;

  const SignUpRequestedEvent ({
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    required this.name,

  });

  @override  
  List<Object?> get props => [email,password,phone,address,name];
}

class GoogleSignInRequestedEvent extends AuthEvent {}

class LogoutRequestedEvent extends AuthEvent {}

