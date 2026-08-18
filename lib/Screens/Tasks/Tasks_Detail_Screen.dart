import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/Provider/Task_Provider.dart';

import '../../Utilties/App_Colors.dart';
import '../../Widgets/Task_Summary_Card.dart';

class TasksDetailScreen extends StatefulWidget {
  const TasksDetailScreen({super.key});

  @override
  State<TasksDetailScreen> createState() => _TasksDetailScreenState();
}

class _TasksDetailScreenState extends State<TasksDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  //   AppBar For Detail Tasks Screen
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.lightColor,
                          ),
                        ),
                        Spacer(),
                        FaIcon(
                          FontAwesomeIcons.penToSquare,
                          color: AppColors.lightColor,
                        ),
                        SizedBox(width: 15),
                        Icon(
                          Icons.menu_rounded,
                          color: AppColors.lightColor,
                          size: 34,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  //   Card Detail Section
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
                        Text(
                          "Complete Flutter Project",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.circle_rounded, color: Colors.red),
                            SizedBox(width: 10),
                            Text(
                              "High",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Description",
                          style: TextStyle(
                            color: AppColors.moderateGrey,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Description...",
                          style: TextStyle(
                            color: AppColors.moderateGrey,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 20),
                        //   BreakDown of the task
                        TaskSummaryCard(
                          icon: Icons.keyboard_option_key,
                          taskOption: "Category",
                          taskOptionsData: "Study",
                        ),
                        SizedBox(height: 5),
                        TaskSummaryCard(
                          icon: Icons.keyboard_option_key,
                          taskOption: "Due Date",
                          taskOptionsData: "Study",
                        ),
                        SizedBox(height: 5),
                        TaskSummaryCard(
                          icon: Icons.keyboard_option_key,
                          taskOption: "Due Time",
                          taskOptionsData: "Study",
                        ),
                        SizedBox(height: 5),
                        TaskSummaryCard(
                          icon: Icons.keyboard_option_key,
                          taskOption: "Reminder",
                          taskOptionsData: "Study",
                        ),
                        SizedBox(height: 5),
                        TaskSummaryCard(
                          icon: Icons.keyboard_option_key,
                          taskOption: "Repeat",
                          taskOptionsData: "Study",
                        ),
                        SizedBox(height: 5),
                        TaskSummaryCard(
                          icon: Icons.keyboard_option_key,
                          taskOption: "Status",
                          taskOptionsData: "Study",
                        ),
                        Spacer(),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.background,
                                  foregroundColor: AppColors.lightColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  "Mark as Completed",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.background,
                                  foregroundColor: AppColors.lightColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  "Delete Task",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
