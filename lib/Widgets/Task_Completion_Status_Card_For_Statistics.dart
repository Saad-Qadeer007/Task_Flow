import 'package:flutter/material.dart';
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
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title),
            SizedBox(height: 5),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: widget.count.toDouble()),
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Text(
                  value.toStringAsFixed(0),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
