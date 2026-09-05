import 'package:flutter/material.dart';

import '../Utilties/App_Colors.dart';

class TaskCompletionStatusCardForStatistics extends StatefulWidget {
  final String title;
  final int count;

  const TaskCompletionStatusCardForStatistics({
    super.key,
    required this.title,
    required this.count,
  });

  @override
  State<TaskCompletionStatusCardForStatistics> createState() =>
      _TaskCompletionStatusCardForStatisticsState();
}

class _TaskCompletionStatusCardForStatisticsState
    extends State<TaskCompletionStatusCardForStatistics> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cards,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title),
            SizedBox(height: 5),
            Text(
              widget.count.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
