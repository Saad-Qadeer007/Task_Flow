import 'package:flutter/material.dart';

class TaskProvider extends ChangeNotifier {
  String priority = "Low";

  void setPriority(String value) {
    print("run");
    priority = value;
    notifyListeners();
  }
}
