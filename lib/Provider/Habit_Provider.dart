import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:task_flow/Models/Habit_Model.dart';
import '../Services/Firebase_Services.dart';

class HabitProvider extends ChangeNotifier {
  List<HabitModel> habits = [];

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
}
