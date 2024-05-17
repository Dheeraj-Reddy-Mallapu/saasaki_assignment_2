import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saasaki_assignment_2/models/task_model.dart';

class TasksDataNotifier extends StateNotifier<Map<String, Task>> {
  TasksDataNotifier() : super({}); // Initialize with the default value

  add(String id, Task task) {
    state[id] = task;
    state = {...state};
  }

  clear() => state = {};
}

final tasksProvider =
    StateNotifierProvider<TasksDataNotifier, Map<String, Task>>(
        (_) => TasksDataNotifier());
