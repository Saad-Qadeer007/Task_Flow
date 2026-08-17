import 'package:flutter/material.dart';
import 'package:task_flow/Utilties/App_Colors.dart';

class ProgressCard extends StatefulWidget {
  const ProgressCard({super.key});

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  @override
  Widget build(BuildContext context) {
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
                Text(
                  "75 %",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text("6 of 8 Tasks Completed"),
              ],
            ),
            Spacer(),
            CircularProgressIndicator(
              value: 0.75,
              color: Colors.green,
              strokeWidth: 10,
            ),
          ],
        ),
      ),
    );
  }
}
