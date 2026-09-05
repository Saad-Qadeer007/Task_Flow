import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:task_flow/Models/Habit_Model.dart';
import '../Services/Firebase_Services.dart';

class HabitProvider extends ChangeNotifier {
  List<HabitModel> habits = [];
  int currentStreak = 0;
  int bestStreak = 0;
  int pre_bestStreak = 0;
  List<int> getDay = [];
  int taskCompletedDayLength = 0;
  bool mondayCompleted = false;
  bool tuesdayCompleted = false;
  bool wednesdayCompleted = false;
  bool thursdayCompleted = false;
  bool fridayCompleted = false;
  bool saturdayCompleted = false;
  bool sundayCompleted = false;

  Future<void> addHabit(HabitModel model) async {
    HabitModel updatedModel = await FirebaseServices().addHabitToFirebase(
      model,
    );
    habits.add(updatedModel);
    notifyListeners();
  }

  Future<void> getHabits() async {
    habits.clear();
    try {
      QuerySnapshot data = await FirebaseServices().getHabitFromFirebase();
      final now = DateTime.now();
      for (final items in data.docs) {
        final habit = HabitModel.toModel(items.data() as Map<String, dynamic>);
        final completedToday = habit.habitCompletedDates.any(
          (date) =>
              date.year == now.year &&
              date.month == now.month &&
              date.day == now.day,
        );
        habit.habitStatus = completedToday;
        habits.add(habit);
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteHabit(String id) async {
    int index = habits.indexWhere((element) => element.habitId == id);
    habits.removeAt(index);
    await FirebaseServices().deleteHabitFromFirebase(id);
    await getHabits();
    notifyListeners();
  }

  Future<void> updateHabit(HabitModel model) async {
    print("Function run");
    final now = DateTime.now();
    final completedToday = model.habitCompletedDates.any(
      (date) =>
          date.year == now.year &&
          date.month == now.month &&
          date.day == now.day,
    );
    if (!completedToday) {
      model.habitCompletedDates.add(now);
    }
    model.habitStatus = true;
    final data = HabitModel.toMap(model);
    await FirebaseServices().updateHabitFromFirebase(data);
    await getHabits();
  }

  Future<void> calculateStreak(HabitModel model) async {
    currentStreak = 0;
    final sortedList = [...model.habitCompletedDates]..sort();
    print(model.habitCompletedDates.length);
    print("Calculate Streak Function Run");
    if (sortedList.isEmpty) {
      print("Data Not Found");
      currentStreak = 0;
      bestStreak = 0;
      notifyListeners();
      return;
    } else {
      currentStreak = 0;
      print("Third Block Run");
      final now = DateTime.now();
      final completedToday = sortedList.any(
        (date) =>
            date.year == now.year &&
            date.month == now.month &&
            date.day == now.day,
      );
      if (completedToday) {
        print("Current Streak");
        var checkDate = now;
        while (true) {
          if (sortedList.any((item) {
            return item.year == checkDate.year &&
                item.month == checkDate.month &&
                item.day == checkDate.day;
          })) {
            currentStreak++;
            final previous_Date = checkDate.subtract(Duration(days: 1));
            checkDate = previous_Date;
          } else {
            break;
          }
          print(currentStreak);
        }
      } else {
        print("scond block for else run");
        var previous_Date = now.subtract(Duration(days: 1));
        if (sortedList.any(
          (date) =>
              date.year == previous_Date.year &&
              date.month == previous_Date.month &&
              date.day == previous_Date.day,
        )) {
          var checkDate = previous_Date;
          while (true) {
            if (sortedList.any((item) {
              return item.year == checkDate.year &&
                  item.month == checkDate.month &&
                  item.day == checkDate.day;
            })) {
              currentStreak++;
              final previous_Date = checkDate.subtract(Duration(days: 1));
              checkDate = previous_Date;
            } else {
              break;
            }
          }
        }
        notifyListeners();
      }
    }
  }

  Future<void> bestStreakCalculator(HabitModel model) async {
    print("Best Streak Function run");
    var currentStreakForCalculatingFinal = 1;
    bestStreak = 1;
    final sortedList = [...model.habitCompletedDates]..sort();
    if (sortedList.isEmpty) {
      bestStreak = 0;
      notifyListeners();
      return;
    } else {
      for (var i = 1; i < sortedList.length; i++) {
        final previous = DateTime(
          sortedList[i - 1].year,
          sortedList[i - 1].month,
          sortedList[i - 1].day,
        );
        final next = DateTime(
          sortedList[i].year,
          sortedList[i].month,
          sortedList[i].day,
        );
        print("previos : $previous , next : $next");
        if (next.difference(previous).inDays == 1) {
          print("Run");
          currentStreakForCalculatingFinal++;
          if (currentStreakForCalculatingFinal > bestStreak) {
            bestStreak = currentStreakForCalculatingFinal;
          }
        } else {
          print("Scond Block Run");
          currentStreakForCalculatingFinal = 1;
        }
      }
    }
    notifyListeners();
  }

  void getCompletedDay(HabitModel model) {
    getDay.clear();
    mondayCompleted = false;
    tuesdayCompleted = false;
    wednesdayCompleted = false;
    thursdayCompleted = false;
    fridayCompleted = false;
    saturdayCompleted = false;
    sundayCompleted = false;
    final sortedList = [...model.habitCompletedDates]..sort();
    final now = DateTime.now();
    final newSortedList = [];
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
    for (final i in sortedList) {
      if ((i.isAfter(startOfWeek) && i.isBefore(endOfWeek)) ||
          i.isAtSameMomentAs(startOfWeek) ||
          i.isAtSameMomentAs(endOfWeek)) {
        newSortedList.add(i);
        getDay.add(i.weekday);
      }
    }
    print(getDay.length);
    final sortGetDay = [...getDay]..sort();
    for (final i in sortGetDay) {
      if (i == 1) {
        mondayCompleted = true;
        print("Monday Completed");
      } else if (i == 2) {
        tuesdayCompleted = true;
        print("Tuesday Completed");
      } else if (i == 3) {
        wednesdayCompleted = true;
        print("Wednesday Completed");
      } else if (i == 4) {
        thursdayCompleted = true;
        print("Thursday Completed");
      } else if (i == 5) {
        fridayCompleted = true;
        print("Friday Completed");
      } else if (i == 6) {
        saturdayCompleted = true;
        print("Saturday Completed");
      } else if (i == 7) {
        sundayCompleted = true;
        print("Sunday Completed");
      }
    }
    notifyListeners();
  }
}
