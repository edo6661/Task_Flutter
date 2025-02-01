import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/api.dart';
import 'package:frontend/core/enums.dart';
import 'package:frontend/core/utils/rgb_to_hex.dart';
import 'package:frontend/features/task/repository/task_local_repository.dart';
import 'package:frontend/features/task/repository/task_remote_repository.dart';
import 'package:frontend/models/task_model.dart';
import 'package:uuid/uuid.dart';
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
      final currentState = state;
      final List<TaskModel> currentTasks =
          currentState is TasksGetSuccess ? currentState.tasks : [];

      final newTask = TaskModel(
        id: const Uuid().v4(),
        title: title,
        description: description,
        color: color,
        dueAt: dueAt,
        userId: userId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isSynced: SyncStatus.unsynced.index,
      );

      final updatedTasks = [...currentTasks, newTask];
      emit(TasksGetSuccess(updatedTasks));

      final res = await taskRemoteRepository.createTask(
          title: title,
          description: description,
          hexColor: rgbToHex(color),
          dueAt: dueAt,
          userId: userId);

      if (res is ApiSuccess) {
        emit(TasksCreateSuccess(res.data!));
        emit(TasksGetSuccess(updatedTasks));
      } else {
        emit(TasksGetSuccess(currentTasks));
        emit(TasksFailed(res.message));
      }
    } catch (e) {
      emit(TasksFailed(e.toString()));
    }
  }

  Future<void> getTasks() async {
    try {
      final res = await taskRemoteRepository.getTasks();

      switch (res) {
        case ApiError _:
          emit(TasksFailed(
            res.message,
          ));
        case ApiSuccess _:
          emit(TasksGetSuccess(res.data!));
      }
    } catch (e) {
      emit(TasksFailed(e.toString()));
    }
  }

  Future<void> syncTasks() async {
    try {
      await taskRemoteRepository.syncDeletedTask();
      await taskRemoteRepository.syncTask();
    } catch (e) {
      emit(TasksFailed(e.toString()));
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final currentState = state;
      final List<TaskModel> currentTasks =
          currentState is TasksGetSuccess ? currentState.tasks : [];
      final tasksBeforeDelete = [...currentTasks];

      final updatedTasks = currentTasks.where((task) => task.id != id).toList();
      emit(TasksGetSuccess(updatedTasks));

      final res = await taskRemoteRepository.deleteTask(id: id);
      if (res is ApiSuccess) {
        emit(TasksDeleteSuccess());
        emit(TasksGetSuccess(updatedTasks));
      } else {
        emit(TasksGetSuccess(tasksBeforeDelete));
        emit(TasksFailed(res.message));
      }
    } catch (e) {
      emit(TasksFailed(e.toString()));
    }
  }

  Future<void> updateTask({required TaskModel task}) async {
    try {
      final currentState = state;
      final List<TaskModel> currentTasks =
          currentState is TasksGetSuccess ? currentState.tasks : [];
      final previousTasks = [...currentTasks];

      final updatedTasks =
          currentTasks.map((t) => t.id == task.id ? task : t).toList();
      emit(TasksGetSuccess(updatedTasks));

      final res = await taskRemoteRepository.updateTask(task: task);
      if (res is ApiSuccess) {
        emit(TasksUpdateSuccess());
        emit(TasksGetSuccess(updatedTasks));
      } else {
        emit(TasksGetSuccess(previousTasks));
        emit(TasksFailed(res.message));
      }
    } catch (e) {
      emit(TasksFailed(e.toString()));
    }
  }
}
