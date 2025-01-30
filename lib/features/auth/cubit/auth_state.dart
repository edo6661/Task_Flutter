// ! part of itu digunakan untuk menggabungkan file yang berbeda menjadi satu file
part of "auth_cubit.dart";

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthSignUp extends AuthState {
  const AuthSignUp({required this.user, required this.message});
  final UserModel user;
  final String message;
}

final class AuthLogin extends AuthState {
  final UserModel user;
  const AuthLogin(this.user);
}

final class LoggedOut extends AuthState {
  const LoggedOut();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}
