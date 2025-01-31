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
    this.message,
  );
  final TaskModel task;
  final String message;
}

final class TasksGetSuccess extends TasksState {
  const TasksGetSuccess(
    this.tasks,
  );
  final List<TaskModel> tasks;
}

final class TasksUpdateSuccess extends TasksState {
  const TasksUpdateSuccess(
    this.message,
  );
  final String message;
}

final class TasksDeleteSuccess extends TasksState {
  const TasksDeleteSuccess(
    this.message,
  );
  final String message;
}

final class TasksFailed extends TasksState {
  const TasksFailed(
    this.message,
  );
  final String message;
}
