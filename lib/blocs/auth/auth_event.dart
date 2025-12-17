part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoadAuthStatus extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginRequested({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  @override
  List<Object> get props => [email, password, rememberMe];
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String address;

  const RegisterRequested({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.address,
  });

  @override
  List<Object> get props => [name, email, phone, password, address];
}

class LogoutRequested extends AuthEvent {}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class UpdateProfileRequested extends AuthEvent {
  final String? name;
  final String? phone;
  final String? address;

  const UpdateProfileRequested({
    this.name,
    this.phone,
    this.address,
  });

  @override
  List<Object> get props => [name ?? '', phone ?? '', address ?? ''];
}