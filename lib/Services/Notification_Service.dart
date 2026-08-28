import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    tz.setLocalLocation(tz.getLocation('Asia/Karachi'));
    try {
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
      );

      await notifications.initialize(settings: settings);

      final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
          notifications
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      await androidPlugin?.requestNotificationsPermission();
    } catch (e) {
      print(e);
    }
  }

  Future<void> showNotification() async {
    print("Notification Function");
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'task_reminders',
          'Task Reminders',
          channelDescription: 'Notifications for task reminders',
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await notifications.show(
      id: 0,
      title: 'Task Reminder 🔔',
      body: 'This is a test notification from TaskFlow!',
      notificationDetails: details,
    );
  }

  Future<void> scheduleNotification(
    String id,
    String title,
    DateTime date,
    TimeOfDay time,
    int? reminder,
  ) async {
    final dueDate = tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    final reminderDate = dueDate.subtract(Duration(minutes: reminder!));

    print("Notification Function");
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'task_reminders',
          'Task Reminders',
          channelDescription: 'Notifications for task reminders',
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    print("Scheduling notification...");
    print("Current time: ${tz.TZDateTime.now(tz.local)}");

    await notifications.zonedSchedule(
      id: ('reminder_$id').hashCode,
      title: 'Task Reminder 🔔',
      body: 'Your task "$title" is due in $reminder minutes',
      scheduledDate: reminderDate,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    await notifications.zonedSchedule(
      id: ('due_$id').hashCode,
      title: 'Task Reminder 🔔',
      body: 'Your task "$title" is due',
      scheduledDate: dueDate,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    print("Notification scheduled!");

    final pending = await notifications.pendingNotificationRequests();

    print("Pending notifications: ${pending.length}");
    print(pending);
  }

  Future<void> cancelNotification(String id) async {
    await notifications.cancel(id: ('reminder_$id').hashCode);
    await notifications.cancel(id: ('due_$id').hashCode);
    print("Notification Cancelled");
  }
}
