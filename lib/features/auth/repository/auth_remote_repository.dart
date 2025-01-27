import 'dart:convert';

import 'package:frontend/core/constants.dart';
import 'package:frontend/core/api.dart';
import 'package:frontend/core/services/sp_service.dart';
import 'package:frontend/core/utils/log_service.dart';
import 'package:frontend/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteRepository {
  final sp = SpService();
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
        LogService.e(responseData.toString());
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
    } catch (e) {
      LogService.e(e.toString());
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
      // ! json decode tuh untuk mengubah string ke json
      final Map<String, dynamic> responseData = jsonDecode(res.body);
      if (res.statusCode != 200) {
        LogService.e(responseData.toString());
        return ApiError(
          message: responseData["message"] ?? "Login failed",
          error: responseData["error"] ?? "",
        );
      }
      final user = UserModel.fromMap(responseData["data"]["user"]);
      final token = responseData["data"]["token"];
      final message = responseData["message"];

      await sp.setToken(token);
      return ApiSuccess(
        message: message,
        data: user,
      );
    } catch (e) {
      LogService.e(e.toString());
      return ApiError(
        message: e.toString(),
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
        LogService.e(responseData.toString());
        return null;
      }
      final user = UserModel.fromMap(responseData["data"]);
      return ApiSuccess(
        message: responseData["message"],
        data: user,
      );
    } catch (e) {
      LogService.e(e.toString());
      return null;
    }
  }

  void logout() async {
    await sp.removeToken();
  }
}
