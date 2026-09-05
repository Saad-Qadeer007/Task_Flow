import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/Provider/Task_Provider.dart';

import '../Utilties/App_Colors.dart';

class CompletionTaskCardStatistics extends StatefulWidget {
  const CompletionTaskCardStatistics({super.key});

  @override
  State<CompletionTaskCardStatistics> createState() =>
      _CompletionTaskCardStatisticsState();
}

class _CompletionTaskCardStatisticsState
    extends State<CompletionTaskCardStatistics> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        return Card(
          color: AppColors.cards,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Completion Rate"),
                    SizedBox(height: 5),
                    Text(
                      "${provider.completedTaskByPercentage.toStringAsFixed(0)} %",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                CircularProgressIndicator(
                  value: provider.completedTaskByPercentage / 100,
                  color: AppColors.successColor,
                  strokeWidth: 5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
