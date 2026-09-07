import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/Models/Task_Model.dart';
import 'package:task_flow/Provider/Task_Provider.dart';
import '../Utilties/App_Colors.dart';

class TaskCards extends StatefulWidget {
  final List<TaskModel> tasks;
  final String id;

  const TaskCards({super.key, required this.id, required this.tasks});

  @override
  State<TaskCards> createState() => _TaskCardsState();
}

class _TaskCardsState extends State<TaskCards> {
  @override
  Widget build(BuildContext context) {
    // Find the task only once
    final task = widget.tasks
        .where((element) => element.id == widget.id)
        .firstOrNull;

    // If task is not found, don't build the card
    if (task == null) {
      return const SizedBox.shrink();
    }

    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
          width: MediaQuery.of(context).size.width,
          child: Card(
            elevation: 1,
            color: Theme.of(context).cardColor,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Task status / priority icon
                  CircleAvatar(
                    backgroundColor: provider.isDark == false
                        ? Colors.grey.shade200
                        : AppColors.moderateGrey,
                    child: task.isCompleted == true
                        ? const Icon(Icons.done_rounded, color: Colors.green)
                        : Icon(
                            Icons.circle_rounded,
                            color: task.taskPriority == "Low"
                                ? Colors.cyan.shade800
                                : task.taskPriority == "Medium"
                                ? Colors.orange.shade600
                                : Colors.red,
                          ),
                  ),

                  const SizedBox(width: 10),

                  // Task information
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.taskTitle.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        task.createdAt.toString().substring(0, 19),
                        style: TextStyle(color: AppColors.moderateGrey),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Priority
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.moderateGrey,
                        size: 18,
                      ),

                      const SizedBox(height: 10),

                      Text(
                        task.taskPriority.toString(),
                        style: TextStyle(
                          color:
                              task.taskPriority.toString().toLowerCase() ==
                                  "low"
                              ? Colors.cyan.shade800
                              : task.taskPriority.toString().toLowerCase() ==
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
      },
    );
  }
}
