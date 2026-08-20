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

  Future<void> getTasks() async {
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
    print("tasks length before delete ${tasks.length}");
    TaskModel task = TaskModel.toModel(data);
    int index = 0;
    for (final i in tasks) {
      if (i.id == task.id) {
        index = tasks.indexOf(i);
      }
    }
    print(index);
    print(tasks[index].taskTitle);
    tasks.removeAt(index);
    print("tasks length after delete ${tasks.length}");
    await FirebaseServices().deleteTaskFromFirebase(data);
    taskCalculation();
    calculateCompletedTasks();
    notifyListeners();
  }

  void updateTask(Map<String, dynamic> data) async {
    await FirebaseServices().updateTaskFromFirebase(data);
    await getTasks();
    tasks.map((item) {
      print("item count in update :  ${item.isCompleted}");
    }).toList();
    calculateCompletedTasks();
    notifyListeners();
  }

  void taskCalculation() async {
    totalTasks = tasks.length;
    calculateCompletedTasks();
    notifyListeners();
  }

  Future<void> calculateCompletedTasks() async {
    print("calculatecompletetasks count runner");
    completedTasks = 0;
    tasks.map((items) {
      print(items.isCompleted);
      return items.isCompleted == true ? completedTasks++ : 0;
    }).toList();
    print("completed task count : $completedTasks");
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
