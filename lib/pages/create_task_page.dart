// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:saasaki_assignment_2/firestore/crud.dart';
import 'package:saasaki_assignment_2/models/task_model.dart';
import 'package:saasaki_assignment_2/utils/date_time_util.dart';
import 'package:saasaki_assignment_2/widgets/my_snackbar.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage(
      {super.key, required this.firestoreOperations, this.task, this.taskId});
  final FirestoreOperations firestoreOperations;
  final Task? task;
  final String? taskId;

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final TextEditingController titleC = TextEditingController();
  final TextEditingController descriptionC = TextEditingController();
  DateTime? deadline;
  DateTime? exptectedTime;
  int selectedPriority = TaskPriority.low.index;
  String selectedStatus = TaskStatus.incomplete.name;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // We are initializing the task data to respective controllers and variables if we are editing it
    if (widget.task != null) {
      titleC.text = widget.task!.title;
      descriptionC.text = widget.task!.description;
      deadline = widget.task?.deadline;
      exptectedTime = widget.task?.exptectedTime;
      selectedPriority = widget.task!.priority;
      selectedStatus = widget.task!.status;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
        actions: [
          // Deletion of Task
          if (widget.task != null)
            IconButton(
              onPressed: () async => widget.firestoreOperations
                  .deleteTask(widget.taskId!)
                  .then((value) => Navigator.pop(context)),
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: myContainer(
                  child: TextFormField(
                    controller: titleC,
                    minLines: 2,
                    maxLines: 3,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '* Field cannot be empty';
                      } else {
                        return null;
                      }
                    },
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Title: *',
                      labelStyle: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
              ),
              myContainer(
                child: TextFormField(
                  controller: descriptionC,
                  minLines: 3,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Description:',
                    labelStyle: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
              myContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Deadline: *',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var now = DateTime.now();
                        deadline = await showDatePicker(
                          context: context,
                          firstDate: now,
                          lastDate: now.add(const Duration(days: 1826)),
                        );

                        if (deadline != null) {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (pickedTime != null) {
                            deadline = deadline!.copyWith(
                              hour: pickedTime.hour,
                              minute: pickedTime.minute,
                            );
                          } else {
                            deadline = null;
                          }
                        }

                        setState(() {});
                      },
                      child: Text(deadline == null
                          ? 'Pick a date and time'
                          : deadline!.toDateString()),
                    ),
                  ],
                ),
              ),
              myContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Expected Time:',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var now = DateTime.now();
                        exptectedTime = await showDatePicker(
                          context: context,
                          firstDate: now,
                          lastDate: now.add(const Duration(days: 1826)),
                        );

                        if (deadline != null) {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (pickedTime != null) {
                            exptectedTime = exptectedTime!.copyWith(
                              hour: pickedTime.hour,
                              minute: pickedTime.minute,
                            );
                          } else {
                            exptectedTime = null;
                          }
                        }

                        setState(() {});
                      },
                      child: Text(exptectedTime == null
                          ? 'Pick a date and time'
                          : exptectedTime!.toDateString()),
                    ),
                  ],
                ),
              ),
              myContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Priority:',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    DropdownMenu(
                      dropdownMenuEntries: TaskPriority.values
                          .map(
                            (e) => DropdownMenuEntry(
                              value: e.index,
                              label: e.name.toUpperCase(),
                            ),
                          )
                          .toList(),
                      initialSelection: selectedPriority,
                      onSelected: (value) =>
                          setState(() => selectedPriority = value!),
                      inputDecorationTheme: const InputDecorationTheme(
                          border: UnderlineInputBorder()),
                    ),
                  ],
                ),
              ),
              if (widget.task != null)
                myContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status:',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      DropdownMenu(
                        dropdownMenuEntries: TaskStatus.values
                            .map(
                              (e) => DropdownMenuEntry(
                                value: e.name,
                                label: e.name.toUpperCase(),
                              ),
                            )
                            .toList(),
                        initialSelection: selectedStatus,
                        onSelected: (value) =>
                            setState(() => selectedStatus = value!),
                        inputDecorationTheme: const InputDecorationTheme(
                            border: UnderlineInputBorder()),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (deadline != null) {
              if (widget.task == null) {
                // Creation of task
                await widget.firestoreOperations
                    .addTask(
                      Task(
                        title: titleC.text,
                        description: descriptionC.text,
                        deadline: deadline!,
                        exptectedTime: exptectedTime,
                        priority: selectedPriority,
                        status: selectedStatus,
                        createdAt: DateTime.now(),
                      ),
                    )
                    .then((value) => Navigator.of(context).pop());
              } else {
                // Updation of the task
                await widget.firestoreOperations
                    .updateTask(
                      Task(
                        title: titleC.text,
                        description: descriptionC.text,
                        deadline: deadline!,
                        exptectedTime: exptectedTime,
                        priority: selectedPriority,
                        status: selectedStatus,
                        createdAt: DateTime.now(),
                      ),
                      widget.taskId!,
                    )
                    .then((value) => Navigator.of(context).pop());
              }
            } else {
              showSnackBar(message: 'Pick a deadline');
            }
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  // To achieve background effect
  Widget myContainer({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withAlpha(50),
            borderRadius: BorderRadius.circular(18.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }
}
