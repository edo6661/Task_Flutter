import 'dart:convert';

import 'package:frontend/core/api.dart';
import 'package:frontend/core/constants.dart';
import 'package:frontend/core/services/sp_service.dart';
import 'package:frontend/core/utils/hex_to_rgb.dart';
import 'package:frontend/core/utils/log_service.dart';
import 'package:frontend/features/task/repository/task_local_repository.dart';
import 'package:frontend/models/task_model.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class TaskRemoteRepository {
  final sp = SpService();
  final taskLocalRepository = TaskLocalRepository();

  Future<ApiResponse<TaskModel>> createTask({
    required String title,
    required String description,
    required String hexColor,
    required DateTime dueAt,
    required String userId,
  }) async {
    try {
      final String? token = await sp.getToken();
      if (token == null) {
        return ApiError(
          message: "Token not found",
        );
      }
      final res = await http.post(
          Uri.parse("${Constants.apiUrl}${Constants.pathCreateTask}"),
          headers: {"Content-Type": "application/json", "x-token": token},
          body: jsonEncode({
            "title": title,
            "description": description,
            "hexColor": hexColor,
            "dueAt": dueAt.toIso8601String(),
          }));
      final responseData = jsonDecode(res.body);
      if (res.statusCode != 201) {
        final task = TaskModel(
          id: const Uuid().v4(),
          title: title,
          description: description,
          color: hexToRgb(hexColor),
          userId: userId,
          dueAt: dueAt,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isSynced: 0,
        );
        await taskLocalRepository.insertTask(task);
        return ApiError(
          message: responseData["message"] ?? "Failed to create task",
          error: responseData["error"] ?? "",
        );
      }

      final task = TaskModel.fromMap(responseData["data"]);
      final message = responseData["message"];
      await taskLocalRepository.insertTask(task);
      return ApiSuccess(
        message: message,
        data: task,
      );
    } catch (e) {
      try {
        final task = TaskModel(
          id: const Uuid().v4(),
          title: title,
          description: description,
          color: hexToRgb(hexColor),
          userId: userId,
          dueAt: dueAt,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isSynced: 0,
        );
        await taskLocalRepository.insertTask(task);
        return ApiSuccess(
          message: "Created task locally, will sync later",
          data: task,
        );
      } catch (e) {
        return ApiError(
          message: e.toString(),
        );
      }
    }
  }

  Future<ApiResponse<List<TaskModel>>> getTasks() async {
    try {
      final String? token = await sp.getToken();
      if (token == null) {
        return ApiError(
          message: "Token not found",
        );
      }
      final res = await http.get(
          Uri.parse("${Constants.apiUrl}${Constants.pathGetTasks}"),
          headers: {"Content-Type": "application/json", "x-token": token});
      final responseData = jsonDecode(res.body);
      if (res.statusCode != 200) {
        final tasks = await taskLocalRepository.getTasks();
        if (tasks.isEmpty) {
          return ApiError(
            message: responseData["message"] ?? "Failed to get tasks",
            error: responseData["error"] ?? "",
          );
        }
        return ApiSuccess(
          message: "Failed to get tasks from server, getting from local",
          data: tasks,
        );
      }
      final tasks = responseData["data"]
          .map<TaskModel>((task) => TaskModel.fromMap(task))
          .toList();

      await taskLocalRepository.insertTasks(tasks);
      return ApiSuccess(
        message: responseData["message"],
        data: tasks,
      );
    } catch (e) {
      final tasks = await taskLocalRepository.getTasks();
      if (tasks.isEmpty) {
        return ApiError(
          message: e.toString(),
        );
      }
      return ApiSuccess(
        message: "Failed to get tasks from server, getting from local",
        data: tasks,
      );
    }
  }

  Future<ApiResponse<bool>> syncTask({
    required List<TaskModel> tasks,
  }) async {
    try {
      final String? token = await sp.getToken();
      if (token == null) {
        return ApiError(
          message: "Token not found",
        );
      }
      final res = await http.post(
          Uri.parse("${Constants.apiUrl}${Constants.pathSyncTask}"),
          headers: {"Content-Type": "application/json", "x-token": token},
          body: jsonEncode(
            tasks.map((task) => task.toMap()).toList(),
          ));
      final responseData = jsonDecode(res.body);
      if (res.statusCode != 201) {
        return ApiError(
          message: responseData["message"] ?? "Failed to create task",
          error: responseData["error"] ?? "",
        );
      }

      return ApiSuccess(
        message: responseData["message"],
        data: true,
      );
    } catch (e) {
      return ApiError(
        message: e.toString(),
      );
    }
  }
}
