import 'dart:convert';
import 'dart:io';

import 'package:frontend/core/constants.dart';
import 'package:frontend/core/api.dart';
import 'package:frontend/core/services/sp_service.dart';
import 'package:frontend/core/utils/log_service.dart';
import 'package:frontend/features/auth/repository/auth_local_repository.dart';
import 'package:frontend/features/task/repository/task_local_repository.dart';
import 'package:frontend/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteRepository {
  final sp = SpService();
  final _authLocalRepository = AuthLocalRepository();
  final _taskLocalRepository = TaskLocalRepository();
  Future<ApiResponse<UserModel>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
          Uri.parse("${Constants.apiUrl}${Constants.pathRegister}"),
          headers: {"Content-Type": "application/json"},
          body:
              jsonEncode({"name": name, "email": email, "password": password}));
      // ! decode dari string ke json
      final Map<String, dynamic> responseData = jsonDecode(res.body);
      if (res.statusCode != 201) {
        return ApiError(
          message: responseData["message"] ?? "Registration failed",
          error: responseData["error"] ?? "",
        );
      }
      final user = UserModel.fromMap(responseData["data"]);
      final message = responseData["message"];
      return ApiSuccess(
        message: message,
        data: user,
      );
    } on SocketException {
      return ApiError(message: Constants.noInternetConnection);
    } catch (e) {
      return ApiError(
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("${Constants.apiUrl}${Constants.pathLogin}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final Map<String, dynamic> responseData = jsonDecode(res.body);

      if (res.statusCode != 200) {
        final userLocal = await _authLocalRepository.getUser();
        if (userLocal == null) {
          return ApiError(
            message: responseData["message"] ?? "Login failed",
          );
        }
        return ApiSuccess(
          message: "Failed to login from server, login from local",
          data: userLocal,
        );
      }

      final user = UserModel.fromMap(responseData["data"]["user"]);
      final token = responseData["data"]["token"];
      final message = responseData["message"];

      await sp.setToken(token);
      await _authLocalRepository.insertUser(user);

      return ApiSuccess(
        message: message,
        data: user,
      );
    } on SocketException {
      return ApiError(message: Constants.noInternetConnection);
    } catch (e) {
      final userLocal = await _authLocalRepository.getUser();
      if (userLocal == null) {
        return ApiError(
          message: e.toString(),
        );
      }
      return ApiSuccess(
        message: "Failed to login from server, login from local",
        data: userLocal,
      );
    }
  }

  Future<ApiResponse<UserModel>?> getUser() async {
    try {
      final token = await sp.getToken();
      if (token == null) {
        return null;
      }
      final res = await http.get(
        Uri.parse("${Constants.apiUrl}${Constants.pathUser}"),
        headers: {
          "Content-Type": "application/json",
          "x-token": token,
        },
      );
      final Map<String, dynamic> responseData = jsonDecode(res.body);
      if (res.statusCode != 200) {
        final userLocal = await _authLocalRepository.getUser();
        if (userLocal == null) {
          return ApiError(
            message: responseData["message"] ?? "Failed to get user",
          );
        }
        return ApiSuccess(
          message: "Failed to get user from server, getting from local",
          data: userLocal,
        );
      }
      final user = UserModel.fromMap(responseData["data"]);
      await _authLocalRepository.insertUser(user);
      return ApiSuccess(
        message: responseData["message"],
        data: user,
      );
    } catch (e) {
      final userLocal = await _authLocalRepository.getUser();
      if (userLocal == null) {
        return ApiError(
          message: e.toString(),
        );
      }
      return ApiSuccess(
        message: "Failed to get user from server, getting from local",
        data: userLocal,
      );
    }
  }

  void logout() async {
    await sp.removeToken();
    await _authLocalRepository.deleteUser();
    await _taskLocalRepository.deleteTasks();
  }
}
