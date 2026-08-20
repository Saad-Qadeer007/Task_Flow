import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_flow/Models/Task_Model.dart';
import '../Services/Firebase_Services.dart';

class TaskProvider extends ChangeNotifier {
  String priority = "Low";
  List<TaskModel> tasks = [];
  bool editMode = false;
  int totalTasks = 0;
  int completedTasks = 0;
  double completedTaskByPercentage = 0.0;

  void setEditModeToOn() {
    editMode = true;
    notifyListeners();
  }

  void setEditModeToOff() {
    editMode = false;
    notifyListeners();
  }

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
    print(tasks.length);
  }

  void deleteTask(Map<String, dynamic> data) async {
    TaskModel task = TaskModel.toModel(data);
    tasks.remove(task);
    await FirebaseServices().deleteTaskFromFirebase(data);
    taskCalculation();
    calculateCompletedTasks();
    notifyListeners();
  }

  void updateTask(Map<String, dynamic> data) async {
    await FirebaseServices().updateTaskFromFirebase(data);
  }

  void taskCalculation() async {
    totalTasks = await FirebaseServices().gettingDataInfoFromFirebase();
    notifyListeners();
  }

  void calculateCompletedTasks() async {
    completedTasks = await FirebaseServices()
        .gettingDataForMarkAsCompletedFromFirebase();
    calculateCompletedTasksPercentage();
    notifyListeners();
  }

  void calculateCompletedTasksPercentage() {
    if (totalTasks == 0) {
      print("function run");
      completedTaskByPercentage = 0.0;
      notifyListeners();
      return;
    }
    completedTaskByPercentage = completedTasks / totalTasks * 100;
    notifyListeners();
  }
}
