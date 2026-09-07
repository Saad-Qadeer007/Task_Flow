import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/Provider/Task_Provider.dart';
import 'package:task_flow/Utilties/App_Colors.dart';

class ProgressCard extends StatefulWidget {
  const ProgressCard({super.key});

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        return Card(
          elevation: 2,
          shadowColor: AppColors.secondaryTextColor,
          color: Theme.of(context).cardColor,
          child: Container(
            padding: EdgeInsets.all(14.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's Progress",
                      style: TextStyle(color: AppColors.moderateGrey),
                    ),
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
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 5),
                    Text(
                      "${provider.completedTasks} of ${provider.totalTasks} Tasks Completed",
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
