import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/Provider/Habit_Provider.dart';
import 'package:task_flow/Widgets/Streak_Card.dart';
import 'package:task_flow/Widgets/Success_SnackBar.dart';

import '../../Models/Habit_Model.dart';
import '../../Utilties/App_Colors.dart';

class HabitDetailScreen extends StatefulWidget {
  final String id;
  final List<HabitModel> habits;

  const HabitDetailScreen({super.key, required this.id, required this.habits});

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  late HabitModel data = widget.habits.firstWhere(
    (element) => element.habitId == widget.id,
  );

  List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.green,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //   AppBar For Detail Tasks Screen
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.lightColor,
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    "Delete Habit",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  content: Text(
                                    "Are you sure you want to delete this habit?",
                                    style: TextStyle(
                                      color: AppColors.moderateGrey,
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        backgroundColor: AppColors.successColor,
                                        foregroundColor: AppColors.lightColor,
                                      ),
                                      child: Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Provider.of<HabitProvider>(
                                          context,
                                          listen: false,
                                        ).deleteHabit(widget.id);
                                        SuccessSnackBar.showSuccessSnackBar(
                                          context,
                                          'Habit Deleted Successfully',
                                        );
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        backgroundColor: AppColors.errorColor,
                                        foregroundColor: AppColors.lightColor,
                                      ),
                                      child: Text("Delete"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Icon(
                              Icons.delete,
                              color: AppColors.lightColor,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  //   Habit Detail Section
                  Container(
                    height: MediaQuery.of(context).size.height * .9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusGeometry.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: AppColors.background,
                    ),
                    padding: EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Text(
                                data.habitTitle.toString()[0].toUpperCase() +
                                    data.habitTitle.toString().substring(1),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data.habitFrequency.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.moderateGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        // Streak Card For Best And Current
                        Row(
                          children: [
                            Expanded(
                              child: StreakCard(
                                title: "Current Streak",
                                days: "7",
                              ),
                            ),
                            Expanded(
                              child: StreakCard(
                                title: "Best Streak",
                                days: "14",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        // Track of the streak
                        Text(
                          "This Week",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: days.map((item) {
                            return Column(
                              children: [
                                Text(item[0]),
                                SizedBox(height: 10),
                                CircleAvatar(),
                              ],
                            );
                          }).toList(),
                        ),

                        SizedBox(height: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsetsGeometry.all(15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                              foregroundColor: AppColors.lightColor,
                              backgroundColor: AppColors.primaryColor,
                            ),
                            child: Text(
                              "Mark As Done",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Divider(),
                        Text(
                          "History",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 100,
                          child: Text(
                            "Coming Soon",
                            style: TextStyle(color: AppColors.moderateGrey),
                          ),
                        ),

                        //   BreakDown of the task
                        SizedBox(height: 60),
                      ],
                    ),
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
