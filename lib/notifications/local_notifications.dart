import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:saasaki_assignment_2/models/task_model.dart';

class NotificationHelper {
  static final NotificationHelper _instance = NotificationHelper._internal();

  factory NotificationHelper() => _instance;
  NotificationHelper._internal(); // The private constructor _internal() ensures that the class can only be instantiated using the factory constructor NotificationHelper().

  Future<void> initializeNotifications() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'tasks',
          channelKey: 'deadline',
          channelName: 'deadline',
          channelDescription: 'Notifications for Deadlines',
          defaultColor: Colors.cyan,
          ledColor: Colors.white,
          ledOnMs: 1000,
          ledOffMs: 500,
          playSound: true,
          importance: NotificationImportance.High,
        ),
      ],
    );

    await AwesomeNotifications().isNotificationAllowed().then((allowed) async {
      if (!allowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  Future<void> scheduleDeadlineNotification({
    required int id,
    required Task task,
  }) async {
    final notifDateTime = task.deadline.subtract(const Duration(minutes: 10));

    if (notifDateTime.isAfter(DateTime.now())) {
      await AwesomeNotifications().createNotification(
        schedule: NotificationCalendar(
          year: notifDateTime.year,
          month: notifDateTime.month,
          day: notifDateTime.day,
          hour: notifDateTime.hour,
          minute: notifDateTime.minute,
        ),
        content: NotificationContent(
          id: id,
          channelKey: 'deadline',
          title: task.title,
          body: 'Deadline is due in 10 minutes',
          // payload: {'data': 'some data'}, // Optional payload data
        ),
      );
    }
  }

  Future<void> cancelNofification(int id) async =>
      await AwesomeNotifications().cancel(id);
  Future<void> cancelAllNofifications() async =>
      await AwesomeNotifications().cancelAll();

  Future<void> cancelAllNotifsByChannel(String channelKey) async =>
      await AwesomeNotifications().cancelNotificationsByChannelKey(channelKey);

  Future turnOnNotifs(Map<String, Task> tasksMap) async {
    await initializeNotifications();

    await cancelAllNotifsByChannel('deadline');

    for (int i = 0; i < tasksMap.values.length; i++) {
      final task = tasksMap.values.elementAt(i);

      await scheduleDeadlineNotification(id: i, task: task);
    }
  }
}
