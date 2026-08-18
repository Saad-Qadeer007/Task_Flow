import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_flow/Models/Task_Model.dart';

import '../Services/Firebase_Services.dart';

class TaskProvider extends ChangeNotifier {
  String priority = "Low";
  List<TaskModel> tasks = [];

  void setPriority(String value) {
    priority = value;
    notifyListeners();
  }

  void addTask(TaskModel task) async {
    tasks.add(task);
    print(tasks);
    await FirebaseServices().addTaskToFirebase(task);
    notifyListeners();
  }

  void getTasks() async {
    tasks.clear();
    print("data deleted from the list");
    print(tasks.length);
    try {
      QuerySnapshot data = await FirebaseServices().getTasksFromFirebase();
      data.docs.map((items) {
        tasks.add(TaskModel.toModel(items.data() as Map<String, dynamic>));
      }).toList();
      print("data loaded in the list");
      print(tasks.length);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
