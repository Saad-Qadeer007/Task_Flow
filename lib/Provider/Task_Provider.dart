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
    await FirebaseServices().addTaskToFirebase(task);
    notifyListeners();
  }

  void getTasks() async {
    tasks.clear();
    try {
      QuerySnapshot data = await FirebaseServices().getTasksFromFirebase();
      data.docs.map((items) {
        tasks.add(TaskModel.toModel(items.data() as Map<String, dynamic>));
      }).toList();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }








}
