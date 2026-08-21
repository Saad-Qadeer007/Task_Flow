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
  int notNullTodayTaskCount = 0;
  int notNullUpcomingTaskCount = 0;

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

  Future<void> filterTodayTasks() async {
    notNullTodayTaskCount = 0;
    print("Filter For Today Run");
    final todayTasks = tasks.map((element) {
      if (element.taskDueDate?.day == DateTime.now().day &&
          element.taskDueDate?.month == DateTime.now().month &&
          element.taskDueDate?.year == DateTime.now().year) {
        return element;
      }
    }).toList();
    for (final i in todayTasks) {
      if (i != null) {
        notNullTodayTaskCount++;
      }
    }
    print(notNullTodayTaskCount);
    notifyListeners();
  }

  void upcomingTasks() {
    notNullUpcomingTaskCount = 0;
    final todayTasks = tasks.map((element) {
      if (element.taskDueDate!.isAfter(DateTime.now())) {
        return element;
      }
    }).toList();
    for (final i in todayTasks) {
      if (i != null) {
        notNullUpcomingTaskCount++;
      }
    }
    print(notNullUpcomingTaskCount);
    notifyListeners();
  }

  void addTask(TaskModel task) async {
    tasks.add(task);
    await FirebaseServices().addTaskToFirebase(task);
    filterTodayTasks();
    upcomingTasks();
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
    await filterTodayTasks();
    taskCalculation();
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
    totalTasks = notNullTodayTaskCount;
    calculateCompletedTasks();
    notifyListeners();
  }

  Future<void> calculateCompletedTasks() async {
    print("calculatecompletetasks count runner");
    completedTasks = 0;
    tasks.map((items) {
      print(items.isCompleted);
      return items.isCompleted == true &&
              items.taskDueDate?.day == DateTime.now().day &&
              items.taskDueDate?.month == DateTime.now().month &&
              items.taskDueDate?.year == DateTime.now().year
          ? completedTasks++
          : 0;
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
