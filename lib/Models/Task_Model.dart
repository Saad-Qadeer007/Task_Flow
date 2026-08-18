import 'package:flutter/material.dart';

class TaskModel {
  String? id;
  String? taskTitle;
  String? taskDescription;
  String? taskCategory;
  String? taskPriority;
  DateTime? taskDueDate;
  TimeOfDay? taskDueTime;
  String? taskReminder;
  String? taskRepeat;
  DateTime? createdAt;

  TaskModel({
    this.id,
    this.taskTitle,
    this.taskDescription,
    this.taskCategory,
    this.taskPriority,
    this.taskDueDate,
    this.taskDueTime,
    this.taskReminder,
    this.taskRepeat,
    this.createdAt
  });

  static Map<String, dynamic> toMap(TaskModel model) {
    return {
      "id": model.id,
      "taskTitle": model.taskTitle,
      "taskDescription": model.taskDescription,
      "taskCategory": model.taskCategory,
      "taskPriority": model.taskPriority,
      "taskDueDate": model.taskDueDate,
      "taskDueTime": {
        "hour": model.taskDueTime?.hour,
        "minute": model.taskDueTime?.minute,
      },
      "taskReminder": model.taskReminder,
      "taskRepeat": model.taskRepeat,
      "createdAt": model.createdAt,
    };
  }

  factory TaskModel.toModel(Map<String, dynamic> map) {
    return TaskModel(
      id: map["id"],
      taskTitle: map["taskTitle"],
      taskDescription: map["taskDescription"],
      taskCategory: map["taskCategory"],
      taskPriority: map["taskPriority"],
      taskDueDate: map["taskDueDate"].toDate(),
      taskDueTime: TimeOfDay(
        hour: map["taskDueTime"]["hour"],
        minute: map["taskDueTime"]["minute"],
      ),
      taskReminder: map["taskReminder"],
      taskRepeat: map["taskRepeat"],
      createdAt: map["createdAt"].toDate(),
    );
  }
}
