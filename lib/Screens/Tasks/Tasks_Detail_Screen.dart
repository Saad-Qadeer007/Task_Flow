import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/Provider/Task_Provider.dart';
import 'package:task_flow/Screens/Tasks/Add_Task_Screen.dart';
import 'package:task_flow/Widgets/Success_SnackBar.dart';
import '../../Utilties/App_Colors.dart';
import '../../Widgets/Task_Summary_Card.dart';

class TasksDetailScreen extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> data;

  const TasksDetailScreen({super.key, required this.data});

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
                        InkWell(
                          onTap: () {
                            provider.setEditModeToOn();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddTaskScreen(data: widget.data.data()),
                              ),
                            );
                          },
                          child: FaIcon(
                            FontAwesomeIcons.penToSquare,
                            color: AppColors.lightColor,
                          ),
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
                          widget.data.data()["taskTitle"],
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
                              widget.data.data()["taskPriority"],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    widget.data
                                            .data()["taskPriority"]
                                            .toString()
                                            .toLowerCase() ==
                                        "low"
                                    ? Colors.cyan.shade800
                                    : widget.data
                                              .data()["taskPriority"]
                                              .toString()
                                              .toLowerCase() ==
                                          "medium"
                                    ? Colors.orange.shade600
                                    : Colors.red,
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
                          widget.data.data()["taskDescription"],
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
                          taskOptionsData: widget.data.data()["taskCategory"],
                        ),
                        SizedBox(height: 5),
                        TaskSummaryCard(
                          icon: Icons.lock_clock,
                          taskOption: "Due Date",
                          taskOptionsData: widget.data
                              .data()["taskDueDate"]
                              .toDate()
                              .toString()
                              .substring(0, 10),
                        ),
                        SizedBox(height: 5),
                        TaskSummaryCard(
                          icon: Icons.timeline,
                          taskOption: "Due Time",
                          taskOptionsData:
                              "${widget.data.data()["taskDueTime"]["hour"]}:${widget.data.data()["taskDueTime"]["minute"]}",
                        ),
                        SizedBox(height: 5),
                        TaskSummaryCard(
                          icon: Icons.notifications_none,
                          taskOption: "Reminder",
                          taskOptionsData:
                              widget.data.data()["taskReminder"] == ""
                              ? "No Data"
                              : widget.data.data()["taskReminder"],
                        ),
                        SizedBox(height: 5),
                        TaskSummaryCard(
                          icon: Icons.timer_rounded,
                          taskOption: "Repeat",
                          taskOptionsData:
                              widget.data.data()["taskReminder"] == ""
                              ? "No Data"
                              : widget.data.data()["taskRepeat"],
                        ),
                        SizedBox(height: 5),
                        TaskSummaryCard(
                          icon: Icons.check_circle_outline_rounded,
                          taskOption: "Status",
                          taskOptionsData:
                              widget.data.data()["isCompleted"] == true
                              ? "Completed"
                              : "Pending",
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
                                  backgroundColor:
                                      widget.data.data()["isCompleted"] == true
                                      ? Colors.green
                                      : AppColors.background,
                                  foregroundColor: AppColors.lightColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () async {
                                  widget.data.data()["isCompleted"] == true
                                      ? SuccessSnackBar.showSuccessSnackBar(
                                          context,
                                          "Task Already Completed",
                                        )
                                      : context
                                            .read<TaskProvider>()
                                            .updateTask({
                                              "id": widget.data.data()["id"],
                                              "isCompleted": true,
                                            });
                                  context
                                      .read<TaskProvider>()
                                      .calculateCompletedTasks();
                                  widget.data.data()["isCompleted"] == true
                                      ? Navigator.pop(context)
                                      : Navigator.pop(context);
                                  widget.data.data()["isCompleted"] == false
                                      ? SuccessSnackBar.showSuccessSnackBar(
                                          context,
                                          "Task Completed Successfully",
                                        )
                                      : null;
                                },
                                child: Text(
                                  "Mark as Completed",
                                  style: TextStyle(
                                    color:
                                        widget.data.data()["isCompleted"] ==
                                            true
                                        ? AppColors.lightColor
                                        : Colors.green,
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
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: AppColors.background,
                                      title: Text(
                                        "Delete Task",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Are U Sure You Want To Delete This Note?",
                                            style: TextStyle(
                                              color: AppColors.moderateGrey,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          child: Text("Cancel"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            context
                                                .read<TaskProvider>()
                                                .deleteTask(widget.data.data());
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            SuccessSnackBar.showSuccessSnackBar(
                                              context,
                                              "Task Deleted Successfully",
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          child: Text("Delete"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
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
