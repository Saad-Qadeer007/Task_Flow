import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/Provider/Task_Provider.dart';

import '../Utilties/App_Colors.dart';

class TaskSummaryCard extends StatefulWidget {
  final String taskOption;
  final String taskOptionsData;
  final IconData icon;

  const TaskSummaryCard({
    super.key,
    required this.taskOption,
    required this.taskOptionsData,
    required this.icon,
  });

  @override
  State<TaskSummaryCard> createState() => _TaskSummaryCardState();
}

class _TaskSummaryCardState extends State<TaskSummaryCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          return Card(
            elevation: 0,
            color: provider.isDark
                ? AppColors.darkBackground
                : AppColors.background,
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  color: provider.isDark == false
                      ? AppColors.secondaryTextColor
                      : AppColors.lightColor,
                  size: 25,
                ),
                SizedBox(width: 10),
                Text(
                  widget.taskOption,
                  style: TextStyle(
                    color: provider.isDark
                        ? AppColors.lightColor
                        : AppColors.moderateGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  widget.taskOptionsData,
                  style: TextStyle(
                    color: provider.isDark
                        ? AppColors.lightColor
                        : AppColors.moderateGrey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
