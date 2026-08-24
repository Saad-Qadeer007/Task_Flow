import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/Models/Task_Model.dart';
import 'package:task_flow/Provider/Task_Provider.dart';
import 'package:task_flow/Screens/Tasks/Tasks_Detail_Screen.dart';
import 'package:task_flow/Widgets/Greeting_Card.dart';
import '../../Utilties/App_Colors.dart';
import '../../Widgets/Progress_Card.dart';
import '../../Widgets/Task_Cards.dart';
import '../Tasks/Add_Task_Screen.dart';

class HomeScreenUi extends StatefulWidget {
  const HomeScreenUi({super.key});

  @override
  State<HomeScreenUi> createState() => _HomeScreenUiState();
}

class _HomeScreenUiState extends State<HomeScreenUi> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    print("intilization run");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().filterTodayTasks();
      context.read<TaskProvider>().upcomingTasks();
      context.read<TaskProvider>().taskCalculation();
      context.read<TaskProvider>().calculateCompletedTasks();
      context.read<TaskProvider>().overDueTasks();
    });
  }

  final now = DateTime.now();

  late final startOfDay = DateTime(now.year, now.month, now.day);

  late final endOfDay = startOfDay.add(const Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            elevation: 2,
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTaskScreen(
                    data: TaskModel(
                      id: "",
                      taskTitle: "",
                      taskDescription: "",
                      taskCategory: "",
                      taskPriority: "",
                      taskDueDate: null,
                      taskDueTime: null,
                      taskReminder: "",
                      taskRepeat: "",
                    ),
                  ),
                ),
              );
            },
            child: Icon(Icons.add, size: 32, color: AppColors.lightColor),
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GreetingCard(),
                    SizedBox(height: 10),
                    ProgressCard(),
                    SizedBox(height: 20),
                    // Handling Due Tasks
                    provider.notNullOverDueTaskCount == 0
                        ? Container()
                        : Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Due Tasks",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                //   StreamBuilder to get the due tasks data from the firebase
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(
                                        FirebaseAuth.instance.currentUser?.uid,
                                      )
                                      .collection("tasks")
                                      .where(
                                        "taskDueDate",
                                        isLessThan: startOfDay,
                                      )
                                      .where("isCompleted", isEqualTo: false)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    final data = snapshot.data?.docs;
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: Text("No Data Found"),
                                      );
                                    } else {
                                      return ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: data?.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      TasksDetailScreen(
                                                        tasks: provider.tasks,
                                                        id: data[index].id,
                                                        upcoming: false,
                                                      ),
                                                ),
                                              );
                                            },
                                            child: TaskCards(
                                              id: data![index].id.toString(),
                                              tasks: provider.tasks,
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),

                    Row(
                      children: [
                        Text(
                          "Today's Tasks",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            context.read<TaskProvider>().overDueTasks();
                          },
                          child: Text(
                            "View All",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    //   Showing the data from the firebase for today
                    provider.tasks.isEmpty ||
                            provider.notNullTodayTaskCount == 0
                        ? SizedBox(
                            height: 400,
                            child: Center(
                              child: Text(
                                "No Task Yet",
                                style: TextStyle(color: AppColors.moderateGrey),
                              ),
                            ),
                          )
                        : StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .collection("tasks")
                                .where(
                                  "taskDueDate",
                                  isGreaterThanOrEqualTo: startOfDay,
                                )
                                .where("taskDueDate", isLessThan: endOfDay)
                                .snapshots(),
                            builder: (context, snapshot) {
                              final data = snapshot.data?.docs;
                              if (!snapshot.hasData) {
                                return Center(child: Text("No Data Found"));
                              } else {
                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: data?.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TasksDetailScreen(
                                                  id: data[index].id
                                                      .toString(),
                                                  tasks: provider.tasks,
                                                  upcoming: false,
                                                ),
                                          ),
                                        );
                                      },
                                      child: TaskCards(
                                        id: data![index].id.toString(),
                                        tasks: provider.tasks,
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                    SizedBox(height: 10),
                    Text(
                      "Upcoming Tasks",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //   Showing the data from the firebase
                    provider.tasks.isEmpty ||
                            provider.notNullUpcomingTaskCount == 0
                        ? SizedBox(
                            height: 400,
                            child: Center(
                              child: Text(
                                "No Upcoming Task Yet",
                                style: TextStyle(color: AppColors.moderateGrey),
                              ),
                            ),
                          )
                        : StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .collection("tasks")
                                .where(
                                  "taskDueDate",
                                  isGreaterThanOrEqualTo: endOfDay,
                                )
                                .limit(3)
                                .snapshots(),
                            builder: (context, snapshot) {
                              final data = snapshot.data?.docs;
                              if (!snapshot.hasData) {
                                return Center(child: Text("No Data Found"));
                              } else {
                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: data?.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TasksDetailScreen(
                                                  tasks: provider.tasks,
                                                  id: data[index].id
                                                      .toString(),
                                                  upcoming: true,
                                                ),
                                          ),
                                        );
                                      },
                                      child: TaskCards(
                                        id: data![index].id.toString(),
                                        tasks: provider.tasks,
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
