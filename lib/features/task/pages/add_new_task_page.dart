import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/common/extent.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/home/pages/home_page.dart';
import 'package:frontend/features/task/cubit/tasks_cubit.dart';
import 'package:frontend/ui/components/center_circular_loading.dart';
import 'package:frontend/ui/components/center_column_container.dart';
import 'package:frontend/ui/components/main_elevated_button.dart';
import 'package:frontend/ui/components/main_text.dart';
import 'package:frontend/ui/components/main_text_field.dart';

class AddNewTaskPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewTaskPage());
  const AddNewTaskPage({super.key});

  @override
  State<AddNewTaskPage> createState() => _AddNewTaskPageState();
}

class _AddNewTaskPageState extends State<AddNewTaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          datePicker(),
          timePicker(),
        ],
        title: MainText(text: "Add New Todo", extent: Large()),
      ),
      body: BlocConsumer<TasksCubit, TasksState>(
        listener: (context, state) {
          if (state is TasksCreateSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.pushAndRemoveUntil(
              context,
              HomePage.route(),
              (_) => false,
            );
          }
          if (state is TasksFailed) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              CenterColumnContainer(
                  child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          ..._buildForm(
                            state is TasksLoading,
                          ),
                          colorPicker(),
                          MainElevatedButton(
                            onPressed: onCreateTask,
                            text: "Create Task",
                            isLoading: state is TasksLoading,
                          ),
                        ],
                      ))),
              if (state is TasksLoading) CenterCircularLoading(),
            ],
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    selectedColor = Colors.lightBlue;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();

  Color selectedColor = Colors.lightBlue;
  onColorChanged(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  onCreateTask() async {
    if (formKey.currentState!.validate()) {
      AuthLogin state = context.read<AuthCubit>().state as AuthLogin;
      await context.read<TasksCubit>().createTask(
          title: titleController.text,
          description: descriptionController.text,
          userId: state.user.id,
          dueAt: selectedDate,
          color: selectedColor);
    }
  }

  Widget datePicker() {
    return IconButton(
        onPressed: () async {
          final newDateDatePicker = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 90)));

          if (newDateDatePicker != null) {
            setState(() {
              selectedDate = DateTime(
                  newDateDatePicker.year,
                  newDateDatePicker.month,
                  newDateDatePicker.day,
                  selectedDate.hour,
                  selectedDate.minute);
            });
          }
        },
        icon: Icon(Icons.date_range));
  }

  // ! untuk menyimpan waktu yang dipilih
  TimeOfDay selectedTime = TimeOfDay.now();
  Widget timePicker() {
    return IconButton(
        onPressed: () async {
          final newTimeDatePicker =
              await showTimePicker(context: context, initialTime: selectedTime);

          if (newTimeDatePicker != null) {
            setState(() {
              selectedTime = newTimeDatePicker;
              selectedDate = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  newTimeDatePicker.hour,
                  newTimeDatePicker.minute);
            });
          }
        },
        icon: Icon(Icons.access_time));
  }

  Widget colorPicker() {
    return ColorPicker(
      heading: MainText(text: "Select Color", extent: Small()),
      subheading: MainText(text: "Select a different shade", extent: Small()),
      pickersEnabled: {
        ColorPickerType.wheel: true,
      },
      color: selectedColor,
      onColorChanged: onColorChanged,
      enableOpacity: true,
      opacitySubheading:
          MainText(text: "Select opacity level", extent: Small()),
    );
  }

  List<Widget> _buildForm(bool isLoading) {
    return [
      MainTextField(
        controller: titleController,
        hintText: "Title",
        validator: (val) {
          if (val!.isEmpty) {
            return "Title cannot be empty";
          }
          return null;
        },
        isEnabled: !isLoading,
      ),
      SizedBox(height: 16),
      MainTextField(
        controller: descriptionController,
        hintText: "Description",
        maxLines: 4,
        validator: (val) {
          if (val!.isEmpty) {
            return "Description cannot be empty";
          }
          return null;
        },
        isEnabled: !isLoading,
      ),
    ];
  }
}
