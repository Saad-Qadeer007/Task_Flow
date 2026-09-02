class HabitModel {
  String habitId;
  String habitTitle;
  String habitFrequency;
  bool habitStatus;
  List<DateTime> habitCompletedDates = [];
  DateTime createdAt;

  HabitModel({
    required this.habitId,
    required this.habitTitle,
    required this.habitFrequency,
    required this.habitStatus,
    required this.habitCompletedDates,
    required this.createdAt,
  });

  static Map<String, dynamic> toMap(HabitModel model) {
    return {
      "habitId": model.habitId,
      "habitTitle": model.habitTitle,
      "habitFrequency": model.habitFrequency,
      "habitStatus": model.habitStatus,
      "habitCompletedDates": model.habitCompletedDates
          .map((date) => date.toIso8601String())
          .toList(),
      "createdAt": model.createdAt.toIso8601String(),
    };
  }

  factory HabitModel.toModel(Map<String, dynamic> map) {
    return HabitModel(
      habitId: map["habitId"],
      habitTitle: map["habitTitle"],
      habitFrequency: map["habitFrequency"],
      habitStatus: map["habitStatus"],
      habitCompletedDates: (map["habitCompletedDates"] as List)
          .map((date) => DateTime.parse(date))
          .toList(),
      createdAt: DateTime.parse(map["createdAt"]),
    );
  }
}
