import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/Models/Task_Model.dart';
import 'package:task_flow/Provider/Task_Provider.dart';
import 'package:task_flow/Screens/Tasks/Add_Task_Screen.dart';
import 'package:task_flow/Widgets/Success_SnackBar.dart';
import '../../Utilties/App_Colors.dart';
import '../../Widgets/Task_Summary_Card.dart';

class TasksDetailScreen extends StatefulWidget {
  final String id;
  final List<TaskModel> tasks;
  final bool upcoming;
  final String date;

  const TasksDetailScreen({
    super.key,
    required this.id,
    required this.tasks,
    required this.upcoming,
    required this.date,
  });

  @override
  State<TasksDetailScreen> createState() => _TasksDetailScreenState();
}

class _TasksDetailScreenState extends State<TasksDetailScreen> {
  late TaskModel data = widget.tasks.firstWhere(
    (element) => element.id == widget.id,
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: provider.isDark
              ? AppColors.moderateGrey
              : AppColors.primaryColor,
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
                        data.isCompleted == true
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  provider.setEditModeToOn();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddTaskScreen(data: data),
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
                      color: provider.isDark
                          ? AppColors.darkBackground
                          : AppColors.background,
                    ),
                    padding: EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.taskTitle.toString(),
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
                              data.taskPriority.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    data.taskPriority
                                            .toString()
                                            .toLowerCase() ==
                                        "low"
                                    ? Colors.cyan.shade800
                                    : data.taskPriority
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
                            color: provider.isDark
                                ? AppColors.lightColor
                                : AppColors.moderateGrey,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          data.taskDescription.toString(),
                          style: TextStyle(
                            color: provider.isDark == false
                                ? AppColors.moderateGrey
                                : AppColors.lightColor,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 20),
                        //   BreakDown of the task
                        TaskSummaryCard(
                          icon: Icons.keyboard_option_key,
                          taskOption: "Category",
                          taskOptionsData: data.taskCategory.toString(),
                        ),
                        SizedBox(height: 5),
                        TaskSummaryCard(
                          icon: Icons.lock_clock,
                          taskOption: "Due Date",
                          taskOptionsData: data.taskDueDate
                              .toString()
                              .substring(0, 10),
                        ),
                        SizedBox(height: 5),
                        TaskSummaryCard(
                          icon: Icons.timeline,
                          taskOption: "Due Time",
                          taskOptionsData:
                              "${data.taskDueTime?.hour}:${data.taskDueTime?.minute}",
                        ),
                        SizedBox(height: 5),
                        TaskSummaryCard(
                          icon: Icons.notifications_none,
                          taskOption: "Reminder",
                          taskOptionsData: data.taskReminder == ""
                              ? "No Data"
                              : data.taskReminder.toString(),
                        ),
                        SizedBox(height: 5),
                        TaskSummaryCard(
                          icon: Icons.timer_rounded,
                          taskOption: "Repeat",
                          taskOptionsData: data.taskReminder == ""
                              ? "No Data"
                              : data.taskRepeat.toString(),
                        ),
                        SizedBox(height: 5),
                        TaskSummaryCard(
                          icon: Icons.check_circle_outline_rounded,
                          taskOption: "Status",
                          taskOptionsData: data.isCompleted == true
                              ? "Completed"
                              : "Pending",
                        ),
                        Spacer(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: data.isCompleted == true
                                      ? Colors.green
                                      : AppColors.background,
                                  foregroundColor: AppColors.lightColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: widget.upcoming == true
                                    ? null
                                    : () {
                                        data.isCompleted == true
                                            ? SuccessSnackBar.showSuccessSnackBar(
                                                context,
                                                "Task Already Completed",
                                              )
                                            : context
                                                  .read<TaskProvider>()
                                                  .updateTask({
                                                    "id": data.id,
                                                    "isCompleted": true,
                                                  }, widget.date);
                                        Navigator.pop(context);
                                        data.isCompleted == false
                                            ? SuccessSnackBar.showSuccessSnackBar(
                                                context,
                                                "Task Completed Successfully",
                                              )
                                            : null;
                                      },
                                child: Text(
                                  "Mark as Completed",
                                  style: TextStyle(
                                    color: data.isCompleted == true
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
                                              color: provider.isDark
                                                  ? AppColors.lightColor
                                                  : AppColors.moderateGrey,
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
                                                .deleteTask(data.id.toString());
                                            context
                                                .read<TaskProvider>()
                                                .getTaskCountForStatistics(
                                                  widget.date,
                                                );
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
