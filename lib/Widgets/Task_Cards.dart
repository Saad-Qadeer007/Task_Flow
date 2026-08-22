import 'package:flutter/material.dart';
import 'package:task_flow/Models/Task_Model.dart';
import '../Utilties/App_Colors.dart';

class TaskCards extends StatefulWidget {
  final TaskModel data;

  const TaskCards({super.key, required this.data});

  @override
  State<TaskCards> createState() => _TaskCardsState();
}

class _TaskCardsState extends State<TaskCards> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 1,
        color: Theme.of(context).cardColor,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                child: widget.data.isCompleted == true
                    ? Icon(Icons.done_rounded, color: Colors.green)
                    : Icon(
                  Icons.circle_rounded,
                  color: widget.data.taskPriority == "Low"
                      ? Colors.cyan.shade800
                      : widget.data.taskPriority == "Medium"
                      ? Colors.orange.shade600
                      : Colors.red,
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data.taskTitle.toString(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    (widget.data.createdAt)
                        .toString()
                        .substring(0, 19),
                    style: TextStyle(color: AppColors.moderateGrey),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.moderateGrey,
                    size: 18,
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.data.taskPriority.toString(),
                    style: TextStyle(
                      color:
                      widget.data
                          .taskPriority
                          .toString()
                          .toLowerCase() ==
                          "low"
                          ? Colors.cyan.shade800
                          : widget.data
                          .toString()
                          .toLowerCase() ==
                          "medium"
                          ? Colors.orange.shade600
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
