import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_flow/Models/Habit_Model.dart';
import 'package:task_flow/Models/Task_Model.dart';
import 'package:task_flow/Provider/Task_Provider.dart';
import 'package:task_flow/Services/Notification_Service.dart';

class FirebaseServices {
  // Firebase Service For Handing the Firebase Operations For The Tasks

  Future<TaskModel> addTaskToFirebase(
    TaskModel model,
    bool isNotification,
  ) async {
    Map<String, dynamic> data = TaskModel.toMap(model);
    try {
      final document = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("tasks")
          .add(data);
      model.id = document.id;
      await document.update({"id": document.id});

      print("Printing isNotification : $isNotification");
      isNotification
          ? await NotificationService().scheduleNotification(
              document.id,
              model.taskTitle.toString(),
              model.taskDueDate!,
              model.taskDueTime!,
              model.taskReminder == "5 Minutes Before"
                  ? 5
                  : model.taskReminder == "10 Minutes Before"
                  ? 10
                  : model.taskReminder == "30 Minutes Before"
                  ? 30
                  : model.taskReminder == "1 Hour Before"
                  ? 60
                  : null,
            )
          : null;
      return model;
    } catch (e) {
      print(e);
      return model;
    }
  }

  Future<QuerySnapshot> getTasksFromFirebase() async {
    final data = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("tasks")
        .get();
    return data;
  }

  Future<void> deleteTaskFromFirebase(String id, bool isNotification) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("tasks")
        .doc(id)
        .delete();

    isNotification ? await NotificationService().cancelNotification(id) : null;
  }

  Future<void> updateTaskFromFirebase(
    Map<String, dynamic> data,
    bool isNotification,
  ) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("tasks")
        .doc(data["id"])
        .update(data);

    if (data["isCompleted"] == true) {
      final document = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("tasks")
          .doc(data["id"])
          .get();

      TaskModel model = TaskModel.toModel(
        document.data() as Map<String, dynamic>,
      );
      print("Printing the task repeat of the task : ${model.taskRepeat}");
      if (model.taskRepeat?.toLowerCase() == "weekly") {
        model.taskDueDate = model.taskDueDate?.add(const Duration(days: 7));
        model.isCompleted = false;
        TaskProvider().addTask(model);
        print("Task Updated And New Task Created ");
      } else if (model.taskRepeat?.toLowerCase() == "monthly") {
        model.taskDueDate = model.taskDueDate?.add(const Duration(days: 30));
        model.isCompleted = false;
        TaskProvider().addTask(model);
        print("Task Updated And New Task Created ");
      } else if (model.taskRepeat?.toLowerCase() == "daily") {
        model.taskDueDate = model.taskDueDate?.add(const Duration(days: 1));
        model.isCompleted = false;
        TaskProvider().addTask(model);
        print("Task Updated And New Task Created ");
      } else if (model.taskRepeat?.toLowerCase() == "yearly") {
        model.taskDueDate = model.taskDueDate?.add(const Duration(days: 365));
        model.isCompleted = false;
        TaskProvider().addTask(model);
      } else {
        print("The Selected is never ");
      }
    }

    if (data["isCompleted"] == true) {
      await NotificationService().cancelNotification(data["id"]);
      return;
    }
    await NotificationService().cancelNotification(data["id"]);
    isNotification
        ? await NotificationService().scheduleNotification(
            data["id"],
            data["taskTitle"],
            data["taskDueDate"],
            TimeOfDay(
              hour: data["taskDueTime"]["hour"],
              minute: data["taskDueTime"]["minute"],
            ),
            data["taskReminder"] == "5 Minutes Before"
                ? 5
                : data["taskReminder"] == "10 Minutes Before"
                ? 10
                : data["taskReminder"] == "30 Minutes Before"
                ? 30
                : data["taskReminder"] == "1 Hour Before"
                ? 60
                : null,
          )
        : null;
  }

  //////////////////////////////////////////////////////////////////////

  // Firebase Service For Handing the Firebase Operations For The Habits

  Future<HabitModel> addHabitToFirebase(HabitModel model) async {
    Map<String, dynamic> data = HabitModel.toMap(model);
    try {
      final document = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("habits")
          .add(data);
      model.habitId = document.id;
      await document.update({"habitId": document.id});

      //   await NotificationService().scheduleNotification(
      //     document.id,
      //     model.taskTitle.toString(),
      //     model.taskDueDate!,
      //     model.taskDueTime!,
      //     model.taskReminder == "5 Minutes Before"
      //         ? 5
      //         : model.taskReminder == "10 Minutes Before"
      //         ? 10
      //         : model.taskReminder == "30 Minutes Before"
      //         ? 30
      //         : model.taskReminder == "1 Hour Before"
      //         ? 60
      //         : null,
      //   );
      return model;
    } catch (e) {
      print(e);
      return model;
    }
  }

  Future<QuerySnapshot> getHabitFromFirebase() async {
    final data = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("habits")
        .get();
    return data;
  }

  Future<void> deleteHabitFromFirebase(String id) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("habits")
        .doc(id)
        .delete();
    //
    // await NotificationService().cancelNotification(id);
  }

  Future<void> updateHabitFromFirebase(Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("habits")
          .doc(data["habitId"])
          .update(data);
    } catch (e) {
      print(e);
    }
  }


}
