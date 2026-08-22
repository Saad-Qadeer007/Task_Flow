import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/Models/Task_Model.dart';
import 'package:task_flow/Provider/Task_Provider.dart';
import 'package:task_flow/Widgets/Task_Catagory_Chip.dart';
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
  final List<String> taskCategories = [
    'Study',
    'Work',
    'Personal',
    'Health',
    'Shopping',
    'Finance',
    'Projects',
    'Other',
  ];

  final now = DateTime.now();

  late final startOfDay = DateTime(now.year, now.month, now.day);

  late final endOfDay = startOfDay.add(const Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: SafeArea(
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
                        InkWell(
                          onTap: () {
                            context
                                .read<TaskProvider>()
                                .setSearchModeByTextField();
                          },
                          child: Icon(
                            Icons.search,
                            color: AppColors.moderateGrey,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () async {
                            SingleChildScrollView(
                              child: SafeArea(
                                child: await showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      padding: EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadiusGeometry.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      height: 400,
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Filter Notes",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: AppColors.darkGrey,
                                              fontWeight: FontWeight(600),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Text(
                                            "Filter By Category",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.darkGrey,
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          Wrap(
                                            spacing: 10,
                                            children: taskCategories.map((
                                              item,
                                            ) {
                                              return TaskCategoryChip(
                                                category: item,
                                              );
                                            }).toList(),
                                          ),
                                          SizedBox(height: 20),
                                          Container(
                                            width: MediaQuery.of(
                                              context,
                                            ).size.width,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.primaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        8.0,
                                                      ),
                                                ),
                                              ),
                                              onPressed: () {
                                                context
                                                    .read<TaskProvider>()
                                                    .searchWithCatagory();
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Apply Filter",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: 10),
                                          Container(
                                            width: MediaQuery.of(
                                              context,
                                            ).size.width,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.primaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        8.0,
                                                      ),
                                                ),
                                              ),
                                              onPressed: null,
                                              // onPressed: () {
                                              //   context
                                              //       .read<TaskProvider>()
                                              //       .changeCategoryToDefault();
                                              // },
                                              child: Text(
                                                "Clear Filter",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                          child: FaIcon(
                            FontAwesomeIcons.filter,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),

                    provider.searchModeByTextField
                        ? Container(
                                padding: EdgeInsets.only(top: 20),
                                width: double.infinity,
                                child: TextField(
                                  onChanged: (value) {
                                    context
                                        .read<TaskProvider>()
                                        .searchByTextField(value);
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: AppColors.moderateGrey,
                                    ),
                                    hintText: "Search",
                                    hintStyle: TextStyle(
                                      color: AppColors.moderateGrey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 500.ms)
                              .slideX(begin: 0.5, end: 0.0)
                        : Container(),

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
                    provider.filteredList.isEmpty ||
                            provider.filteredList.every((item) {
                              return item == null;
                            })
                        ? Container(
                            child: Column(
                              children: [
                                provider.tasks.isEmpty
                                    ? Container(
                                        height: 400,
                                        child: Center(
                                          child: Text(
                                            "No Task Yet",
                                            style: TextStyle(
                                              color: AppColors.moderateGrey,
                                            ),
                                          ),
                                        ),
                                      )
                                    : activeDateChip == "All"
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                .doc(
                                                  FirebaseAuth
                                                      .instance
                                                      .currentUser
                                                      ?.uid,
                                                )
                                                .collection("tasks")
                                                .where(
                                                  'taskDueDate',
                                                  isGreaterThanOrEqualTo:
                                                      startOfDay,
                                                )
                                                .where(
                                                  'taskDueDate',
                                                  isLessThanOrEqualTo: endOfDay,
                                                )
                                                .where(
                                                  "isCompleted",
                                                  isEqualTo: false,
                                                )
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              final data = snapshot.data?.docs;
                                              if (!snapshot.hasData) {
                                                return Center(
                                                  child: Text("No Data Found"),
                                                );
                                              } else {
                                                return ListView.builder(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
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
                                                                  data:
                                                                      data[index],
                                                                  upcoming:
                                                                      false,
                                                                ),
                                                          ),
                                                        );
                                                      },
                                                      child: TaskCards(
                                                        data: TaskModel.toModel(
                                                          data![index].data(),
                                                        ),
                                                      ),
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
                                                .doc(
                                                  FirebaseAuth
                                                      .instance
                                                      .currentUser
                                                      ?.uid,
                                                )
                                                .collection("tasks")
                                                .where(
                                                  'taskDueDate',
                                                  isGreaterThan: endOfDay,
                                                )
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              final data = snapshot.data?.docs;
                                              if (!snapshot.hasData) {
                                                return Center(
                                                  child: Text("No Data Found"),
                                                );
                                              } else {
                                                return ListView.builder(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
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
                                                                  data:
                                                                      data[index],
                                                                  upcoming:
                                                                      false,
                                                                ),
                                                          ),
                                                        );
                                                      },
                                                      child: TaskCards(
                                                        data: TaskModel.toModel(
                                                          data![index].data(),
                                                        ),
                                                      ),
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
                                                .doc(
                                                  FirebaseAuth
                                                      .instance
                                                      .currentUser
                                                      ?.uid,
                                                )
                                                .collection("tasks")
                                                .where(
                                                  'isCompleted',
                                                  isEqualTo: true,
                                                )
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              final data = snapshot.data?.docs;
                                              if (!snapshot.hasData) {
                                                return Center(
                                                  child: Text("No Data Found"),
                                                );
                                              } else {
                                                return ListView.builder(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
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
                                                                  data:
                                                                      data[index],
                                                                  upcoming:
                                                                      false,
                                                                ),
                                                          ),
                                                        );
                                                      },
                                                      child: TaskCards(
                                                        data: TaskModel.toModel(
                                                          data![index].data(),
                                                        ),
                                                      ),
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
                                            .doc(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser
                                                  ?.uid,
                                            )
                                            .collection("tasks")
                                            .where(
                                              'taskDueDate',
                                              isGreaterThanOrEqualTo:
                                                  startOfDay,
                                            )
                                            .where(
                                              'taskDueDate',
                                              isLessThanOrEqualTo: endOfDay,
                                            )
                                            .where(
                                              "isCompleted",
                                              isEqualTo: false,
                                            )
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          final data = snapshot.data?.docs;
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child: Text("No Data Found"),
                                            );
                                          } else {
                                            return ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
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
                                                  child: TaskCards(
                                                    data: TaskModel.toModel(
                                                      data![index].data(),
                                                    ),
                                                  ),
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
                                            .doc(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser
                                                  ?.uid,
                                            )
                                            .collection("tasks")
                                            .where(
                                              'taskDueDate',
                                              isGreaterThan: endOfDay,
                                            )
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          final data = snapshot.data?.docs;
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child: Text("No Data Found"),
                                            );
                                          } else {
                                            return ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
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
                                                  child: TaskCards(
                                                    data: TaskModel.toModel(
                                                      data![index].data(),
                                                    ),
                                                  ),
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
                                            .doc(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser
                                                  ?.uid,
                                            )
                                            .collection("tasks")
                                            .where(
                                              'isCompleted',
                                              isEqualTo: true,
                                            )
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          final data = snapshot.data?.docs;
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child: Text("No Data Found"),
                                            );
                                          } else {
                                            return ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
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
                                                  child: TaskCards(
                                                    data: TaskModel.toModel(
                                                      data![index].data(),
                                                    ),
                                                  ),
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
                          )
                        : Column(
                            children: [
                              Text("Hello"),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: provider.filteredList.length,
                                itemBuilder: (context, index) {
                                  return TaskCards(
                                    data: provider.filteredList[index],
                                  );
                                },
                              ),
                            ],
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
