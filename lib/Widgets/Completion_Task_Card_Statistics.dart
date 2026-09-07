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
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Completion Rate"),
                    SizedBox(height: 5),
                    TweenAnimationBuilder<double>(
                      tween: Tween(
                        begin: 0,
                        end: (provider.completedTaskByPercentage / 100) * 100,
                      ),
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                      builder: (context, value, child) {
                        return Text(
                          "${value.toStringAsFixed(0)} %",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Spacer(),
                TweenAnimationBuilder<double>(
                  tween: Tween(
                    begin: 0,
                    end: provider.completedTaskByPercentage / 100,
                  ),
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  builder: (context, value, child) {
                    return CircularProgressIndicator(
                      value: value,
                      color: AppColors.successColor,
                      strokeWidth: 5,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
