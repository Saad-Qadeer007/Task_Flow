import 'package:flutter/material.dart';
import 'package:task_flow/Models/Habit_Model.dart';

import '../Utilties/App_Colors.dart';

class HabitCard extends StatefulWidget {
  final List<HabitModel> habit;
  final String id;

  const HabitCard({super.key, required this.id, required this.habit});

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  @override
  Widget build(BuildContext context) {
    // Find the task only once
    final habit = widget.habit
        .where((element) => element.habitId == widget.id)
        .firstOrNull;

    // If task is not found, don't build the card
    if (habit == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 1,
        color: Theme.of(context).cardColor,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task status / priority icon
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                child: Icon(Icons.circle_rounded, color: Colors.green),
              ),

              const SizedBox(width: 10),

              // Task information
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Text(
                      habit.habitTitle.toString()[0].toUpperCase() +
                          habit.habitTitle.toString().substring(1),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    habit.habitFrequency.toString()[0].toUpperCase() +
                        habit.habitFrequency.toString().substring(1),
                    style: TextStyle(color: AppColors.moderateGrey),
                  ),
                ],
              ),

              const Spacer(),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "7 / 7 days",
                    style: TextStyle(color: AppColors.moderateGrey),
                  ),
                  SizedBox(height: 5),
                  Text(
                    habit.habitStatus == false ? "Pending" : "Completed",
                    style: TextStyle(color: AppColors.moderateGrey),
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
