import 'package:flutter/material.dart';
import 'package:task_flow/Models/Task_Model.dart';
import '../Utilties/App_Colors.dart';

class TaskCards extends StatefulWidget {
  final List<TaskModel> tasks;
  final String id;

  const TaskCards({super.key, required this.id, required this.tasks});

  @override
  State<TaskCards> createState() => _TaskCardsState();
}

class _TaskCardsState extends State<TaskCards> {
  late final data = widget.tasks.firstWhere(
    (element) => element.id == widget.id,
  );

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
                child: data.isCompleted == true
                    ? Icon(Icons.done_rounded, color: Colors.green)
                    : Icon(
                        Icons.circle_rounded,
                        color: data.taskPriority == "Low"
                            ? Colors.cyan.shade800
                            : data.taskPriority == "Medium"
                            ? Colors.orange.shade600
                            : Colors.red,
                      ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.taskTitle.toString(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    (data.createdAt).toString().substring(0, 19),
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
                    data.taskPriority.toString(),
                    style: TextStyle(
                      color: data.taskPriority.toString().toLowerCase() == "low"
                          ? Colors.cyan.shade800
                          : data.toString().toLowerCase() == "medium"
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
