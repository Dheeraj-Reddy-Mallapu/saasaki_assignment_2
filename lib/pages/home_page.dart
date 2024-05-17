import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saasaki_assignment_2/firestore/crud.dart';
import 'package:saasaki_assignment_2/models/task_model.dart';
import 'package:saasaki_assignment_2/notifications/local_notifications.dart';
import 'package:saasaki_assignment_2/pages/create_task_page.dart';
import 'package:saasaki_assignment_2/riverpod/auth.dart';
import 'package:saasaki_assignment_2/riverpod/tasks_data.dart';
import 'package:saasaki_assignment_2/widgets/my_snackbar.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  var firestoreOperations = FirestoreOperations();
  var notifHelper = NotificationHelper();

  init() async {
    firestoreOperations.startTasksStream(ref);

    await notifHelper.initializeNotifications();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authProvider);
    final tasksMap = ref.watch(tasksProvider);

    notifHelper.turnOnNotifs(tasksMap);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            onPressed: () async => auth.logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: tasksMap.keys.isEmpty
          ? const Center(
              child: Text('Start creating tasks by clicking on + icon'))
          : ListView.builder(
              itemCount: tasksMap.keys.length,
              itemBuilder: (context, index) {
                final task = tasksMap.values.elementAt(index);
                final taskId = tasksMap.keys.elementAt(index);

                return Card(
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: task.description.isNotEmpty
                        ? Text(
                            task.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : null,
                    trailing: IconButton(
                      onPressed: () async {
                        String status = TaskStatus.incomplete.name;
                        if (task.status == TaskStatus.complete.name) {
                          status = TaskStatus.incomplete.name;
                          showSnackBar(message: 'Marked as Incomplete');
                        } else if (task.status == TaskStatus.incomplete.name) {
                          status = TaskStatus.ongoing.name;
                          showSnackBar(message: 'Marked as Ongoing');
                        } else {
                          status = TaskStatus.complete.name;
                          showSnackBar(message: 'Marked as Complete');
                        }

                        await firestoreOperations.updateTask(
                            task.copyWith(status: status), taskId);
                      },
                      icon: Icon(task.status == TaskStatus.complete.name
                          ? Icons.check_box
                          : task.status == TaskStatus.ongoing.name
                              ? Icons.indeterminate_check_box
                              : Icons.check_box_outline_blank),
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreateTaskPage(
                        firestoreOperations: firestoreOperations,
                        task: task,
                        taskId: taskId,
                      ),
                    )),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CreateTaskPage(
            firestoreOperations: firestoreOperations,
          ),
        )),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
