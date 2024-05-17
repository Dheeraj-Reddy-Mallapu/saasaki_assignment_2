import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saasaki_assignment_2/models/task_model.dart';
import 'package:saasaki_assignment_2/riverpod/tasks_data.dart';
import 'package:saasaki_assignment_2/widgets/my_snackbar.dart';

class FirestoreOperations {
  final db = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? _tasksCollectionSubscription;
  var uid = FirebaseAuth.instance.currentUser!.uid;

  // Creating a new Task in firestore (CREATE)
  Future<void> addTask(Task task) async {
    try {
      await db.collection(uid).add(task.toMap());
    } on Exception catch (e) {
      showSnackBar(message: e.toString());
    }
  }

  // Fetching data from firestore (READ)
  void startTasksStream(WidgetRef ref) {
    _tasksCollectionSubscription = db.collection(uid).snapshots().listen(
      (event) {
        ref.read(tasksProvider.notifier).clear();
        event.docs
            .map((e) => ref
                .read(tasksProvider.notifier)
                .add(e.id, Task.fromMap(e.data())))
            .toList();
      },
      onError: (e) => showSnackBar(message: e.toString()),
    );
  }

  void stopTasksStream() => _tasksCollectionSubscription?.cancel();

  // Updating an existing Task in firestore (UPDATE)
  Future<void> updateTask(Task task, String taskId) async {
    try {
      await db.collection(uid).doc(taskId).update(task.toMap());
    } on Exception catch (e) {
      showSnackBar(message: e.toString());
    }
  }

  // Deleting an existing Task in firestore (DELETE)
  Future<void> deleteTask(String taskId) async {
    try {
      await db.collection(uid).doc(taskId).delete();
    } on Exception catch (e) {
      showSnackBar(message: e.toString());
    }
  }
}
