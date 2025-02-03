import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/common/extent.dart';
import 'package:frontend/core/utils/is_same_date.dart';
import 'package:frontend/core/utils/log_service.dart';
import 'package:frontend/core/utils/strengthen_color.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/auth/pages/sign_in_page.dart';
import 'package:frontend/features/home/widgets/date_selector.dart';
import 'package:frontend/features/home/widgets/task_card.dart';
import 'package:frontend/features/task/cubit/tasks_cubit.dart';
import 'package:frontend/features/task/pages/add_new_task_page.dart';
import 'package:frontend/features/task/pages/update_task_page.dart';
import 'package:frontend/models/task_model.dart';
import 'package:frontend/ui/components/center_circular_loading.dart';
import 'package:frontend/ui/components/center_column_container.dart';
import 'package:frontend/ui/components/empty_data.dart';
import 'package:frontend/ui/components/main_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/ui/extension.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomePage());
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription connectivitySubscription;

  @override
  void initState() {
    super.initState();
    context.read<TasksCubit>().getTasks();
    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((data) async {
      if (mounted) {
        if (data.contains(ConnectivityResult.wifi) ||
            data.contains(ConnectivityResult.mobile) ||
            data.contains(ConnectivityResult.ethernet)) {
          await context.read<TasksCubit>().syncTasks();
        }
      }
    });
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  void onLogout(
    BuildContext context,
  ) async {
    await context.read<AuthCubit>().logout();
    Navigator.pushAndRemoveUntil(
      context,
      SignInPage.route(),
      (_) => false,
    );
  }

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const MainText(
            text: "My Todos",
            extent: Large(),
            textAlign: TextAlign.center,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  onLogout(context);
                },
                icon: Icon(CupertinoIcons.arrow_right_square),
                color: Theme.of(context).colorScheme.primary),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(AddNewTaskPage.route());
          },
          child: Icon(
            CupertinoIcons.add,
          ),
        ),
        body: BlocConsumer<TasksCubit, TasksState>(
          listener: (context, state) {
            if (state is TasksFailed) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is TasksLoading) {
              return CenterCircularLoading();
            }
            if (state is TasksFailed) {
              return MainText(
                text: state.message,
                extent: Large(),
                maxLines: 100,
              );
            }
            if (state is TasksGetSuccess) {
              final tasksByDate = state.tasks
                  .where((task) => isSameDate(task.dueAt, selectedDate))
                  .toList();
              tasksByDate.sort((a, b) => b.createdAt.compareTo(a.createdAt));

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Expanded(child: _buildTaskList(tasksByDate, state.tasks)),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ));
  }

  Widget _buildEmptyTask() {
    return SliverToBoxAdapter(child: EmptyData(title: "No Task Available"));
  }

  Widget _buildTaskList(List<TaskModel> filteredTask, List<TaskModel> tasks) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child:
          _buildTasks(filteredTask, tasks, context, context.read<TasksCubit>()),
    );
  }

  Widget _buildTasks(
    List<TaskModel> filteredTasks,
    List<TaskModel> tasks,
    BuildContext context,
    TasksCubit tasksCubit,
  ) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: DateSelector(
              selectedDate: selectedDate,
              onSelectDate: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
              taskLengthByDate: (date) {
                return tasks
                    .where((task) => isSameDate(task.dueAt, date))
                    .length;
              }),
        ),
        const SliverPadding(
          padding: EdgeInsets.only(top: 16),
        ),
        filteredTasks.isEmpty
            ? _buildEmptyTask()
            : _buildTask(filteredTasks, context, tasksCubit),
      ],
    );
  }

  Widget _buildTask(
    List<TaskModel> tasks,
    BuildContext context,
    TasksCubit tasksCubit,
  ) {
    return SliverList(
      key: const PageStorageKey('task_list'),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final task = tasks[index];
          return Dismissible(
            key: Key(task.id),
            // ! startToEnd
            secondaryBackground: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.only(right: 16),
              alignment: Alignment.centerRight,
              child: Icon(
                CupertinoIcons.trash,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            // ! endToStart
            background: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.only(left: 16),
              alignment: Alignment.centerLeft,
              child: Icon(
                CupertinoIcons.pencil,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            direction: DismissDirection.horizontal,
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                context.read<TasksCubit>().deleteTask(task.id);
              } else if (direction == DismissDirection.startToEnd) {
                Navigator.of(context).push(UpdateTaskPage.route(task));
              }
            },
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                Navigator.of(context).push(UpdateTaskPage.route(task));
                return false; // ga hapus item dari ui
              } else if (direction == DismissDirection.endToStart) {
                bool? confirmDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: MainText(
                        text: "Hapus Task",
                        extent: Large(),
                      ),
                      content: MainText(
                        text: "Are you sure want to delete this task?",
                        extent: Small(),
                        maxLines: 2,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: MainText(
                            text: "Batal",
                            color: Colors.green,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: MainText(
                            text: "Hapus",
                            color: Colors.red,
                          ),
                        )
                      ],
                    );
                  },
                );
                return confirmDelete ?? false;
              }
              return false;
            },
            child: Row(
              children: [
                TaskCard(
                    color: task.color,
                    headerText: task.title,
                    descritionText: task.description,
                    dueAt: task.dueAt),
              ],
            ),
          ).withSpacing(bottom: 16);
        },
        childCount: tasks.length,
      ),
    );
  }
}
