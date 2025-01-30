import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/api.dart';
import 'package:frontend/core/utils/log_service.dart';
import 'package:frontend/core/utils/rgb_to_hex.dart';
import 'package:frontend/features/task/repository/task_local_repository.dart';
import 'package:frontend/features/task/repository/task_remote_repository.dart';
import 'package:frontend/models/task_model.dart';
part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(const TasksInitial());
  final taskRemoteRepository = TaskRemoteRepository();
  final taskLocalRepository = TaskLocalRepository();

  Future<void> createTask({
    required String title,
    required String description,
    required Color color,
    required DateTime dueAt,
    required String userId,
  }) async {
    try {
      emit(TasksLoading());
      final res = await taskRemoteRepository.createTask(
          title: title,
          description: description,
          hexColor: rgbToHex(color),
          dueAt: dueAt,
          userId: userId);

      if (res is ApiSuccess) {
        emit(TasksCreateSuccess(res.data!, res.message));
        await getTasks();
      } else {
        emit(TasksFailed(res.message));
      }
    } catch (e) {
      emit(TasksFailed(e.toString()));
    }
  }

  Future<void> getTasks() async {
    try {
      emit(TasksLoading());
      final res = await taskRemoteRepository.getTasks();

      switch (res) {
        case ApiError _:
          emit(TasksFailed(res.message));
        case ApiSuccess _:
          emit(TasksGetSuccess(res.data!));
      }
    } catch (e) {
      emit(TasksFailed(e.toString()));
    }
  }

  Future<void> syncTasks() async {
    try {
      final unsyncedTasks = await taskLocalRepository.getUnsyncedTasks();
      if (unsyncedTasks.isEmpty) {
        return;
      }
      final res = await taskRemoteRepository.syncTask(
        tasks: unsyncedTasks,
      );
      if (res is ApiSuccess) {
        for (final task in unsyncedTasks) {
          await taskLocalRepository.updateSync(
            id: task.id,
            isSynced: 1,
          );
        }
      }
    } catch (e) {
      emit(TasksFailed(e.toString()));
    }
  }
}
