import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// Event ketika aplikasi pertama kali dibuka (cek apakah sudah login/punya token)
class AppStarted extends AuthEvent {}

// Event ketika user menekan tombol login
class LoginPressed extends AuthEvent {
  final String email;
  final String password;

  const LoginPressed({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

// Event ketika user menekan tombol logout
class LoggedOut extends AuthEvent {}