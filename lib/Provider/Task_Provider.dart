import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_flow/Models/Task_Model.dart';
import 'package:task_flow/Services/Notification_Service.dart';
import '../Services/Firebase_Services.dart';

class TaskProvider extends ChangeNotifier {
  String priority = "High";
  bool isDark = false;
  String greeting = "Good Morning";
  bool isNotification = false;
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
  late var filterStatisticsTasks = [];
  late var filterStatisticsCompletedTasks = [];
  late var filterStatisticsPendingTasks = [];
  double completedTaskPercentageForStatistics = 0.0;

  final now = DateTime.now();

  late final startOfDay = DateTime(now.year, now.month, now.day);

  late final endOfDay = startOfDay.add(const Duration(days: 1));

  Future<void> toggleDarkMode() async {
    isDark = !isDark;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("isDark", isDark);
    notifyListeners();
  }

  Future<void> toggleNotification() async {
    isNotification = !isNotification;
    isNotification == false
        ? NotificationService().cancelAllNotification()
        : NotificationService().initialize();
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("isNotification", isNotification);
    getTasks();
    notifyListeners();
  }

  void getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      greeting = "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      greeting = "Good Afternoon";
    } else if (hour >= 17 && hour < 21) {
      greeting = "Good Evening";
    } else {
      greeting = "Good Night";
    }
    notifyListeners();
  }

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
    final todayTasks = tasks.map((element) {
      final dueDateTime = DateTime(
        element.taskDueDate!.year,
        element.taskDueDate!.month,
        element.taskDueDate!.day,
        element.taskDueTime!.hour,
        element.taskDueTime!.minute,
      );

      if (dueDateTime.isBefore(DateTime.now()) &&
          element.isCompleted == false) {
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
    TaskModel model = await FirebaseServices().addTaskToFirebase(
      task,
      isNotification,
    );
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
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.getBool("isNotification") == null
          ? isNotification = false
          : isNotification = pref.getBool("isNotification")!;
      pref.getBool("isDark") == null
          ? isDark = false
          : isDark = pref.getBool("isDark")!;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void deleteTask(String id) async {
    int index = tasks.indexWhere((element) => element.id == id);
    tasks.removeAt(index);
    await FirebaseServices().deleteTaskFromFirebase(id, isNotification);
    await getTasks();
    searchWithDate();
    await filterTodayTasks();
    taskCalculation();
    notifyListeners();
  }

  void updateTask(Map<String, dynamic> data, String date) async {
    await FirebaseServices().updateTaskFromFirebase(data, isNotification);
    await getTasks();
    getTaskCountForStatistics(date);
    filterTodayTasks();
    taskCalculation();
    overDueTasks();
    upcomingTasks();
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
              items.taskDueDate?.year == DateTime.now().year &&
              items.taskDueTime!.isAfter(
                TimeOfDay(
                  hour: DateTime.now().hour,
                  minute: DateTime.now().minute,
                ),
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

      if (searchWithDateChips == true) {
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
          final today = DateTime.now();

          final startOfTomorrow = DateTime(
            today.year,
            today.month,
            today.day + 1,
          );

          matchDate = !task.taskDueDate!.isBefore(startOfTomorrow);
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
    final upcoming = tasks.where((element) => element.id == id).firstOrNull;

    // If task is not found, don't build the card
    if (upcoming != null) {
      isUpcoming = upcoming.taskDueDate!.isBefore(endOfDay) ? false : true;
    }
    notifyListeners();
  }

  void getTaskCountForStatistics(String date) {
    DateTime now = DateTime.now();
    if (date.toLowerCase() == "this month") {
      filterStatisticsTasks = [];
      filterStatisticsCompletedTasks = [];
      filterStatisticsPendingTasks = [];
      final filteredmonthtask = tasks.map((item) {
        if (item.taskDueDate?.month == now.month) {
          return item;
        }
      }).toList();
      for (var i in filteredmonthtask) {
        if (i != null) {
          filterStatisticsTasks.add(i);
        }
      }
      if (filterStatisticsTasks.isNotEmpty) {
        filterStatisticsTasks.map((item) {
          if (item.isCompleted == true) {
            filterStatisticsCompletedTasks.add(item);
          } else {
            filterStatisticsPendingTasks.add(item);
          }
        }).toList();
      } else {
        filterStatisticsTasks = [];
        filterStatisticsCompletedTasks = [];
        filterStatisticsPendingTasks = [];
      }
      notifyListeners();
    } else if (date.toLowerCase() == "this year") {
      filterStatisticsTasks = [];
      filterStatisticsCompletedTasks = [];
      filterStatisticsPendingTasks = [];
      final filteredTask = tasks.map((item) {
        if (item.taskDueDate?.year == now.year) {
          return item;
        }
      }).toList();
      for (var i in filteredTask) {
        if (i != null) {
          filterStatisticsTasks.add(i);
        }
      }
      if (filterStatisticsTasks.isNotEmpty) {
        filterStatisticsTasks.map((item) {
          if (item.isCompleted == true) {
            filterStatisticsCompletedTasks.add(item);
          } else {
            filterStatisticsPendingTasks.add(item);
          }
        }).toList();
      } else {
        filterStatisticsTasks = [];
        filterStatisticsCompletedTasks = [];
        filterStatisticsPendingTasks = [];
      }
      notifyListeners();
    } else {
      filterStatisticsTasks = [];
      filterStatisticsCompletedTasks = [];
      filterStatisticsPendingTasks = [];
      final now = DateTime.now();
      final startOfWeek = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: now.weekday - 1));
      DateTime endOfWeek = startOfWeek.add(Duration(days: 7));
      final filteredTask = tasks.map((item) {
        if ((item.taskDueDate!.isAfter(startOfWeek) &&
                item.taskDueDate!.isBefore(endOfWeek)) ||
            item.taskDueDate!.isAtSameMomentAs(startOfWeek)) {
          return item;
        }
      }).toList();
      for (var i in filteredTask) {
        if (i != null) {
          filterStatisticsTasks.add(i);
        }
      }
      if (filterStatisticsTasks.isNotEmpty) {
        filterStatisticsTasks.map((item) {
          if (item.isCompleted == true) {
            filterStatisticsCompletedTasks.add(item);
          } else {
            filterStatisticsPendingTasks.add(item);
          }
        }).toList();
      } else {
        filterStatisticsTasks = [];
        filterStatisticsCompletedTasks = [];
        filterStatisticsPendingTasks = [];
      }
    }
    calculateCompletedTaskPercentageForStatistics();
    notifyListeners();
  }

  void calculateCompletedTaskPercentageForStatistics() {
    if (filterStatisticsTasks.isEmpty) {
      completedTaskByPercentage = 0.0;
    } else {
      completedTaskByPercentage =
          filterStatisticsCompletedTasks.length /
          filterStatisticsTasks.length *
          100;
    }
    notifyListeners();
  }

  void clearTaskProviderData() {
    tasks.clear();
    clearFilter();
    getGreeting();
    isDark = false;
    isNotification = false;
    priority = "High";
    selectedCatagory = "";
    activeDateChip = "All";
    filteredList = tasks;
    isUpcoming = false;
    totalTasks = 0;
    completedTasks = 0;
    completedTaskByPercentage = 0.0;
    notNullOverDueTaskCount = 0;
    notNullTodayTaskCount = 0;
    notNullUpcomingTaskCount = 0;
    searchModeByTextField = false;
    searchModeByCategory = false;
    searchModeByPriority = false;
    searchWithDateChips = false;
    searchText = "";
    notifyListeners();
  }
}
