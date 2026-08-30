import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_flow/Models/Task_Model.dart';
import '../Services/Firebase_Services.dart';

class TaskProvider extends ChangeNotifier {
  String priority = "High";
  List<TaskModel> tasks = [];
  bool editMode = false;
  int totalTasks = 0;
  int completedTasks = 0;
  double completedTaskByPercentage = 0.0;
  int notNullTodayTaskCount = 0;
  int notNullUpcomingTaskCount = 0;
  int notNullOverDueTaskCount = 0;
  bool searchModeByTextField = false;
  bool searchModeByCategory = false;
  bool searchModeByPriority = false;
  bool searchWithDateChips = false;
  String searchText = "";
  late var filteredList = tasks;
  bool isUpcoming = false;
  List<String> taskCategories = [
    'Study',
    'Work',
    'Personal',
    'Health',
    'Shopping',
    'Finance',
    'Projects',
    'Other',
  ];
  List<String> taskPriority = ["Low", "Medium", "High"];
  late String selectedCatagory = "";
  String activeDateChip = "All";

  final now = DateTime.now();

  late final startOfDay = DateTime(now.year, now.month, now.day);

  late final endOfDay = startOfDay.add(const Duration(days: 1));

  void categorySelectionHandler(String value) {
    selectedCatagory = value;
    searchModeByCategory = true;
    notifyListeners();
  }

  void setSearchModeByTextField() {
    searchModeByTextField = !searchModeByTextField;
    notifyListeners();
  }

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
    final todayTasks = tasks.map((element) {
      if (element.taskDueDate?.day == DateTime.now().day &&
          element.taskDueDate?.month == DateTime.now().month &&
          element.taskDueDate?.year == DateTime.now().year &&
          element.taskDueTime!.isAfter(
            TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
          )) {
        return element;
      }
    }).toList();
    for (final i in todayTasks) {
      if (i != null) {
        notNullTodayTaskCount++;
      }
    }
    notifyListeners();
  }

  void upcomingTasks() {
    final now = DateTime.now();

    final startOfDay = DateTime(now.year, now.month, now.day);

    final endOfDay = startOfDay.add(const Duration(days: 1));

    notNullUpcomingTaskCount = 0;

    final upcoming = tasks.map((element) {
      if (element.taskDueDate != null &&
          !element.taskDueDate!.isBefore(endOfDay)) {
        return element;
      }
    }).toList();

    for (final task in upcoming) {
      if (task != null) {
        notNullUpcomingTaskCount++;
      }
    }

    notifyListeners();
  }

  void overDueTasks() {
    notNullOverDueTaskCount = 0;
    final now = DateTime.now();
    late final startOfDay = DateTime(now.year, now.month, now.day);
    final todayTasks = tasks.map((element) {
      if (element.taskDueTime!.isBefore(
            TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
          ) &&
          element.isCompleted == false &&
          !element.taskDueDate!.isAfter(startOfDay)) {
        return element;
      }
    }).toList();
    for (final i in todayTasks) {
      if (i != null) {
        notNullOverDueTaskCount++;
      }
    }
    notifyListeners();
  }

  void addTask(TaskModel task) async {
    TaskModel model = await FirebaseServices().addTaskToFirebase(task);
    tasks.add(model);
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
  }

  void deleteTask(String id) async {
    int index = tasks.indexWhere((element) => element.id == id);
    tasks.removeAt(index);
    await FirebaseServices().deleteTaskFromFirebase(id);
    await getTasks();
    searchWithDate();
    await filterTodayTasks();
    taskCalculation();
    notifyListeners();
  }

  void updateTask(Map<String, dynamic> data) async {
    await FirebaseServices().updateTaskFromFirebase(data);
    await getTasks();
    filterTodayTasks();
    taskCalculation();
    overDueTasks();
    notifyListeners();
  }

  void taskCalculation() async {
    totalTasks = notNullTodayTaskCount;
    calculateCompletedTasks();
    notifyListeners();
  }

  Future<void> calculateCompletedTasks() async {
    completedTasks = 0;
    tasks.map((items) {
      return items.isCompleted == true &&
              items.taskDueDate?.day == DateTime.now().day &&
              items.taskDueDate?.month == DateTime.now().month &&
              items.taskDueDate?.year == DateTime.now().year && items.taskDueTime!.isAfter(
        TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
      )
          ? completedTasks++
          : 0;
    }).toList();
    calculateCompletedTasksPercentage();
    notifyListeners();
  }

  void calculateCompletedTasksPercentage() {
    if (totalTasks == 0) {
      completedTaskByPercentage = 0.0;
      notifyListeners();
      return;
    }
    completedTaskByPercentage = completedTasks / totalTasks * 100;
    notifyListeners();
  }

  //   Functions for handling searching

  void searchByTextField(String value) {
    searchText = value;
    if (searchText == "") {
      searchModeByTextField = false;
    }
    applyFilter();
    notifyListeners();
  }

  void searchWithCatagory() {
    searchModeByCategory = true;
    applyFilter();
  }

  void searchWithPriority() {
    searchModeByPriority = true;
    applyFilter();
  }

  void searchWithDate() {
    searchWithDateChips = true;
    applyFilter();
  }

  void clearFilter() {
    searchModeByTextField = false;
    searchModeByCategory = false;
    searchModeByPriority = false;
    searchWithDateChips = false;
    searchText = "";
    selectedCatagory = "";
    priority = "High";
    activeDateChip = "All";
    filteredList = tasks;
    notifyListeners();
  }

  void applyFilter() {
    final searchedResult = tasks.where((task) {
      bool matchesText = true;
      bool matchesCategory = true;
      bool matchesPriority = true;
      bool matchDate = true;

      // Text filter
      if (searchModeByTextField && searchText.isNotEmpty) {
        matchesText =
            task.taskTitle!.toLowerCase().contains(searchText.toLowerCase()) ||
            task.taskDescription!.toLowerCase().contains(
              searchText.toLowerCase(),
            );
      }

      // Category filter
      if (searchModeByCategory && selectedCatagory.isNotEmpty) {
        matchesCategory = task.taskCategory == selectedCatagory;
      }

      // Priority filter
      if (searchModeByPriority && priority.isNotEmpty) {
        matchesPriority = task.taskPriority == priority;
      }

      if (searchWithDateChips) {
        if (activeDateChip == "All") {
          filteredList = tasks;
        } else if (activeDateChip == "Today") {
          matchDate =
              task.taskDueDate?.day == DateTime.now().day &&
              task.taskDueDate?.month == DateTime.now().month &&
              task.taskDueDate?.year == DateTime.now().year &&
              task.taskDueTime!.isAfter(
                TimeOfDay(
                  hour: DateTime.now().hour,
                  minute: DateTime.now().minute,
                ),
              );
        } else if (activeDateChip == "Upcoming") {
          matchDate = task.taskDueDate!.isAfter(endOfDay) ? true : false;
        } else if (activeDateChip == "Completed") {
          matchDate = task.isCompleted == true ? true : false;
        }
      }

      // ALL active filters must match
      return matchesText && matchesCategory && matchesPriority && matchDate;
    }).toList();

    filteredList = searchedResult;

    notifyListeners();
  }

  void upcomingTaskTracker(String id) {
    final upcoming = filteredList.firstWhere((item) => item.id == id);
    isUpcoming = upcoming.taskDueDate!.isBefore(endOfDay) ? false : true;
    notifyListeners();
  }
}
