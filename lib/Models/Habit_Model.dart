import 'package:cloud_firestore/cloud_firestore.dart';

class HabitModel {
  String habitId;
  String habitTitle;
  String habitFrequency;
  bool habitStatus;
  List<DateTime> habitCompletedDates = [];

  HabitModel({
    required this.habitId,
    required this.habitTitle,
    required this.habitFrequency,
    required this.habitStatus,
    required this.habitCompletedDates,
  });

  static Map<String, dynamic> toMap(HabitModel model) {
    return {
      "habitId": model.habitId,
      "habitTitle": model.habitTitle,
      "habitFrequency": model.habitFrequency,
      "habitStatus": model.habitStatus,
      "habitCompletedDates": model.habitCompletedDates
          .map((date) => Timestamp.fromDate(date))
          .toList(),
    };
  }

  factory HabitModel.toModel(Map<String, dynamic> map) {
    return HabitModel(
      habitId: map["habitId"],
      habitTitle: map["habitTitle"],
      habitFrequency: map["habitFrequency"],
      habitStatus: map["habitStatus"],
      habitCompletedDates: (map["habitCompletedDates"] as List)
          .map((date) => (date as Timestamp).toDate())
          .toList(),
    );
  }
}
