import 'package:flutter/material.dart';

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
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 0,
        color: AppColors.background,
        child: Row(
          children: [
            Icon(widget.icon, color: AppColors.secondaryTextColor,size: 25,),
            SizedBox(width: 10),
            Text(
              widget.taskOption,
              style: TextStyle(
                color: AppColors.moderateGrey,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Text(
              widget.taskOptionsData,
              style: TextStyle(
                color: AppColors.moderateGrey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
