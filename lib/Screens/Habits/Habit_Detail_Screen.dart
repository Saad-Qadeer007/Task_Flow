import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/Provider/Habit_Provider.dart';
import 'package:task_flow/Provider/Task_Provider.dart';
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
        return Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            return Scaffold(
              backgroundColor: taskProvider.isDark == false
                  ? AppColors.successColor
                  : AppColors.moderateGrey,
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            backgroundColor:
                                                AppColors.successColor,
                                            foregroundColor:
                                                AppColors.lightColor,
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            backgroundColor:
                                                AppColors.errorColor,
                                            foregroundColor:
                                                AppColors.lightColor,
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
                          color: taskProvider.isDark == false
                              ? AppColors.background
                              : AppColors.darkBackground,
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
                                    data.habitTitle
                                            .toString()[0]
                                            .toUpperCase() +
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
                                    days: provider.currentStreak.toString(),
                                  ),
                                ),
                                Expanded(
                                  child: StreakCard(
                                    title: "Best Streak",
                                    days: provider.bestStreak.toString(),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            // Track of the streak
                            InkWell(
                              onTap: () {
                                // context.read<HabitProvider>().getCompletedDay();
                              },
                              child: Text(
                                "This Week",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
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
                                    CircleAvatar(
                                      backgroundColor:
                                          provider.getDay.contains(
                                            days.indexOf(item) + 1,
                                          )
                                          ? Colors.green
                                          : Colors.grey.shade300,
                                      child:
                                          provider.getDay.contains(
                                            days.indexOf(item) + 1,
                                          )
                                          ? FaIcon(
                                              FontAwesomeIcons.check,
                                              color: AppColors.lightColor,
                                              size: 16,
                                            )
                                          : null,
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),

                            SizedBox(height: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<HabitProvider>().updateHabit(
                                    data,
                                  );
                                  context.read<HabitProvider>().calculateStreak(
                                    data,
                                  );
                                  context
                                      .read<HabitProvider>()
                                      .bestStreakCalculator(data);
                                  context.read<HabitProvider>().getCompletedDay(
                                    data,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsetsGeometry.all(15.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                  foregroundColor: AppColors.lightColor,
                                  backgroundColor: AppColors.primaryColor,
                                ),
                                child: data.habitStatus
                                    ? Text(
                                        "Completed",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : Text(
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
                            Row(
                              children: [
                                Text(
                                  "History",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  "See All",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.moderateGrey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Container(
                              child: data.habitCompletedDates.isEmpty
                                  ? SizedBox(
                                      height: 300,
                                      width: double.infinity,
                                      child: Center(
                                        child: Text(
                                          "No Habit Completion Yet",
                                          style: TextStyle(
                                            color: AppColors.moderateGrey,
                                          ),
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          data.habitCompletedDates.length,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            Icon(
                                              Icons.circle_outlined,
                                              color: AppColors.moderateGrey,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "${data.habitCompletedDates[index].day} ${data.habitCompletedDates[index].month == 1
                                                  ? "Jan"
                                                  : data.habitCompletedDates[index].month == 2
                                                  ? "Feb"
                                                  : data.habitCompletedDates[index].month == 3
                                                  ? "Mar"
                                                  : data.habitCompletedDates[index].month == 4
                                                  ? "Apr"
                                                  : data.habitCompletedDates[index].month == 5
                                                  ? "May"
                                                  : data.habitCompletedDates[index].month == 6
                                                  ? "Jun"
                                                  : data.habitCompletedDates[index].month == 7
                                                  ? "Jul"
                                                  : data.habitCompletedDates[index].month == 8
                                                  ? "Aug"
                                                  : data.habitCompletedDates[index].month == 9
                                                  ? "Sep"
                                                  : data.habitCompletedDates[index].month == 10
                                                  ? "Oct"
                                                  : data.habitCompletedDates[index].month == 11
                                                  ? "Nov"
                                                  : "Dec"} ${data.habitCompletedDates[index].year}",
                                            ),
                                            Spacer(),
                                            FaIcon(
                                              FontAwesomeIcons.circleCheck,
                                              size: 20,
                                              color: AppColors.successColor,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                            ),
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
      },
    );
  }
}
