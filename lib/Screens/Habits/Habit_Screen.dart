import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/Provider/Habit_Provider.dart';
import 'package:task_flow/Screens/Habits/Habit_Detail_Screen.dart';
import 'package:task_flow/Widgets/Habit_Card.dart';

import '../../Utilties/App_Colors.dart';
import 'Add_Habit_Screen.dart';

class HabitScreen extends StatefulWidget {
  const HabitScreen({super.key});

  @override
  State<HabitScreen> createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        // onPressed: () {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => AddTaskScreen(
        //         data: TaskModel(
        //           id: "",
        //           taskTitle: "",
        //           taskDescription: "",
        //           taskCategory: "",
        //           taskPriority: "",
        //           taskDueDate: null,
        //           taskDueTime: null,
        //           taskReminder: "",
        //           taskRepeat: "",
        //         ),
        //       ),
        //     ),
        //   );
        // },
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddHabitScreen()),
          );
        },
        child: Icon(Icons.add, size: 32, color: AppColors.lightColor),
      ),
      body: Consumer<HabitProvider>(
        builder: (context, habitProvider, child) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    //   Appbar for habit screen
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Text(
                            "My Habits",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight(600),
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              print(habitProvider.habits.length);
                            },
                            child: Icon(Icons.add, size: 30),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    habitProvider.habits.isEmpty
                        ? SizedBox(
                            width: double.infinity,
                            height: 600,
                            child: Center(
                              child: Text(
                                "No Habits Yet",
                                style: TextStyle(color: AppColors.moderateGrey),
                              ),
                            ),
                          )
                        : StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .collection("habits")
                                .snapshots(),
                            builder: (context, snapshot) {
                              final data = snapshot.data?.docs;
                              if (!snapshot.hasData) {
                                return Center(child: Text("No Data Found"));
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
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
                                                HabitDetailScreen(
                                                  id: data[index].id.toString(),
                                                  habits: habitProvider.habits,
                                                ),
                                          ),
                                        );
                                      },
                                      child: HabitCard(
                                        id: data![index].id.toString(),
                                        habit: habitProvider.habits,
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
          );
        },
      ),
    );
  }
}
