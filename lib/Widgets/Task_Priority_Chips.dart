import 'package:flutter/material.dart';

import '../Utilties/App_Colors.dart';

class TaskPriorityChips extends StatefulWidget {
  final String item;

  const TaskPriorityChips({super.key, required this.item});

  @override
  State<TaskPriorityChips> createState() => _TaskPriorityChipsState();
}

class _TaskPriorityChipsState extends State<TaskPriorityChips> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(8.0),
        ),
        backgroundColor: widget.item.toLowerCase() == "low"
            ? Colors.cyan.shade400
            : widget.item.toLowerCase() == "medium"
            ? Colors.orange.shade600
            : Colors.red,
      ),
      onPressed: () {},
      child: Text(
        widget.item,
        style: TextStyle(
          color: AppColors.lightColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
