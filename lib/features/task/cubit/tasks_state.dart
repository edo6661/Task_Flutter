part of 'tasks_cubit.dart';

sealed class TasksState {
  const TasksState();
}

final class TasksInitial extends TasksState {
  const TasksInitial();
}

final class TasksLoading extends TasksState {
  const TasksLoading();
}

final class TasksCreateSuccess extends TasksState {
  const TasksCreateSuccess(
    this.task,
  );
  final TaskModel task;
}

final class TasksGetSuccess extends TasksState {
  const TasksGetSuccess(
    this.tasks,
  );
  final List<TaskModel> tasks;
}

final class TasksUpdateSuccess extends TasksState {
  const TasksUpdateSuccess();
}

final class TasksDeleteSuccess extends TasksState {
  const TasksDeleteSuccess();
}

final class TasksFailed extends TasksState {
  const TasksFailed(
    this.message,
  );
  final String message;
}
