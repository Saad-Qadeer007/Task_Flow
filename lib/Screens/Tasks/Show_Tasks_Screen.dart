import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/Provider/Task_Provider.dart';

import '../../Utilties/App_Colors.dart';
import '../../Widgets/Task_Cards.dart';
import '../Home/Home_Screen.dart';
import 'Tasks_Detail_Screen.dart';

class ShowTasksScreen extends StatefulWidget {
  const ShowTasksScreen({super.key});

  @override
  State<ShowTasksScreen> createState() => _ShowTasksScreenState();
}

class _ShowTasksScreenState extends State<ShowTasksScreen> {
  List<String> dateChipList = ["All", "Today", "Upcoming", "Completed"];
  String activeDateChip = "All";

  final now = DateTime.now();

  late final startOfDay = DateTime(now.year, now.month, now.day);

  late final endOfDay = startOfDay.add(const Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //   AppBar For The Show All Task Screen
                  // Header of the add task screen
                  SizedBox(height: 10),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.moderateGrey,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "All Tasks",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight(600),
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.search,
                        color: AppColors.moderateGrey,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.filter_alt_rounded,
                        color: AppColors.moderateGrey,
                        size: 30,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  //   Chips For Filter By Date
                  Wrap(
                    runSpacing: 2,
                    spacing: 1,
                    children: dateChipList
                        .map(
                          (e) => ActionChip(
                            backgroundColor: activeDateChip == e
                                ? AppColors.primaryColor
                                : AppColors.background,
                            onPressed: () {
                              setState(() {
                                activeDateChip = e;
                              });
                            },
                            label: Text(
                              e,
                              style: TextStyle(
                                color: activeDateChip == e
                                    ? AppColors.lightColor
                                    : AppColors.moderateGrey,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 20),
                  //   Showing the data from the firebase
                  provider.tasks.isEmpty
                      ? Container(
                          height: 400,
                          child: Center(
                            child: Text(
                              "No Task Yet",
                              style: TextStyle(color: AppColors.moderateGrey),
                            ),
                          ),
                        )
                      : activeDateChip == "All"
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Today's Tasks",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //   Showing the data from the firebase
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(FirebaseAuth.instance.currentUser?.uid)
                                  .collection("tasks")
                                  .where(
                                    'taskDueDate',
                                    isGreaterThanOrEqualTo: startOfDay,
                                  )
                                  .where(
                                    'taskDueDate',
                                    isLessThanOrEqualTo: endOfDay,
                                  )
                                  .where("isCompleted", isEqualTo: false)
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
                                                    data: data[index],
                                                    upcoming: false,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: TaskCards(data: data![index]),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                            Text(
                              "Upcoming Tasks",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //   Showing the data from the firebase
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(FirebaseAuth.instance.currentUser?.uid)
                                  .collection("tasks")
                                  .where('taskDueDate', isGreaterThan: endOfDay)
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
                                                    data: data[index],
                                                    upcoming: false,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: TaskCards(data: data![index]),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                            Text(
                              "Completed Tasks",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //   Showing the data from the firebase
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(FirebaseAuth.instance.currentUser?.uid)
                                  .collection("tasks")
                                  .where('isCompleted', isEqualTo: true)
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
                                                    data: data[index],
                                                    upcoming: false,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: TaskCards(data: data![index]),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        )
                      : activeDateChip == "Today"
                      ? StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .collection("tasks")
                              .where(
                                'taskDueDate',
                                isGreaterThanOrEqualTo: startOfDay,
                              )
                              .where(
                                'taskDueDate',
                                isLessThanOrEqualTo: endOfDay,
                              )
                              .where("isCompleted", isEqualTo: false)
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
                                                data: data[index],
                                                upcoming: false,
                                              ),
                                        ),
                                      );
                                    },
                                    child: TaskCards(data: data![index]),
                                  );
                                },
                              );
                            }
                          },
                        )
                      : activeDateChip == "Upcoming"
                      ? StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .collection("tasks")
                              .where('taskDueDate', isGreaterThan: endOfDay)
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
                                                data: data[index],
                                                upcoming: false,
                                              ),
                                        ),
                                      );
                                    },
                                    child: TaskCards(data: data![index]),
                                  );
                                },
                              );
                            }
                          },
                        )
                      : activeDateChip == "Completed"
                      ? StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .collection("tasks")
                              .where('isCompleted', isEqualTo: true)
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
                                                data: data[index],
                                                upcoming: false,
                                              ),
                                        ),
                                      );
                                    },
                                    child: TaskCards(data: data![index]),
                                  );
                                },
                              );
                            }
                          },
                        )
                      : Container(),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
