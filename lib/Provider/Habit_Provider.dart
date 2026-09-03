import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:task_flow/Models/Habit_Model.dart';
import '../Services/Firebase_Services.dart';

class HabitProvider extends ChangeNotifier {
  List<HabitModel> habits = [];
  int currentStreak = 0;
  int bestStreak = 0;

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
    bestStreak = 0;
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

        print(currentStreak);
        if (currentStreak > bestStreak) {
          bestStreak = currentStreak;
          notifyListeners();
          return;
        }
        notifyListeners();
        return;
      }
    }
  }
}
