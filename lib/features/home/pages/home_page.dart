import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/common/extent.dart';
import 'package:frontend/core/utils/is_same_date.dart';
import 'package:frontend/core/utils/strengthen_color.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/auth/pages/sign_in_page.dart';
import 'package:frontend/features/home/widgets/date_selector.dart';
import 'package:frontend/features/home/widgets/task_card.dart';
import 'package:frontend/features/task/cubit/tasks_cubit.dart';
import 'package:frontend/features/task/pages/add_new_task_page.dart';
import 'package:frontend/models/task_model.dart';
import 'package:frontend/ui/components/center_circular_loading.dart';
import 'package:frontend/ui/components/center_column_container.dart';
import 'package:frontend/ui/components/main_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        if (data.contains(ConnectivityResult.wifi)) {
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
  ) {
    context.read<AuthCubit>().logout();
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
          scrolledUnderElevation: 0,
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
        body: BlocBuilder<TasksCubit, TasksState>(
          builder: (context, state) {
            if (state is TasksLoading) {
              return CenterCircularLoading();
            }
            if (state is TasksFailed) {
              return CenterColumnContainer(
                child: MainText(
                  text: state.message,
                  extent: Large(),
                  maxLines: 100,
                ),
              );
            }
            if (state is TasksGetSuccess) {
              final tasksByDate = state.tasks
                  .where((task) => isSameDate(task.dueAt, selectedDate))
                  .toList();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  spacing: 20,
                  children: [
                    DateSelector(
                        selectedDate: selectedDate,
                        onSelectDate: (date) {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                        taskLengthByDate: (date) {
                          return state.tasks
                              .where((task) => isSameDate(task.dueAt, date))
                              .length;
                        }),
                    Expanded(
                        child: tasksByDate.isEmpty
                            ? _buildEmptyTask()
                            : _buildTaskList(tasksByDate)),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ));
  }

  Widget _buildEmptyTask() {
    return Center(child: MainText(text: "Task is empty"));
  }

  Widget _buildTaskList(List<TaskModel> tasks) {
    return ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(
              height: 12,
            ),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Row(
            children: [
              TaskCard(
                  color: task.color,
                  headerText: task.title,
                  descritionText: task.description),
              const SizedBox(width: 20),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: strengthenColor(task.color, 0.6)),
              ),
              SizedBox(width: 4),
              MainText(
                text: DateFormat('hh:mm a').format(task.dueAt),
                extent: ExtraSmall(),
                color: Theme.of(context).colorScheme.onSurface.withValues(
                      alpha: 0.6,
                    ),
              )
            ],
          );
        });
  }
}
