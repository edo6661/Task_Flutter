import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/api.dart';
import 'package:frontend/core/utils/log_service.dart';
import 'package:frontend/features/auth/repository/auth_remote_repository.dart';
import 'package:frontend/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());
  final AuthRemoteRepository _authRemoteRepository = AuthRemoteRepository();
  void register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      final res = await _authRemoteRepository.register(
          name: name, email: email, password: password);
      emit(
        AuthSignUp(
          user: res.data ?? UserModel.defaultUser(),
          message: res.message,
        ),
      );
    } catch (e) {
      LogService.e(e.toString());
      emit(AuthError(e.toString()));
    }
  }

  void login({required String email, required String password}) async {
    try {
      emit(AuthLoading());
      final res =
          await _authRemoteRepository.login(email: email, password: password);
      emit(AuthLogin(res.data ?? UserModel.defaultUser(), res.message));
    } catch (e) {
      LogService.e(e.toString());
      emit(AuthError(e.toString()));
    }
  }

  void getUser() async {
    try {
      emit(AuthLoading());
      final res = await _authRemoteRepository.getUser();
      if (res is ApiSuccess) {
        emit(AuthLoggedIn(
          res?.data ?? UserModel.defaultUser(),
        ));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      LogService.e(e.toString());
      emit(AuthError(e.toString()));
    }
  }

  void logout() async {
    try {
      emit(AuthLoading());
      _authRemoteRepository.logout();
      emit(AuthInitial());
    } catch (e) {
      LogService.e(e.toString());
      emit(AuthError(e.toString()));
    }
  }
}
