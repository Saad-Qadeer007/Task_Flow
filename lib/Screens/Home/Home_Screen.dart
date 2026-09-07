import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/Provider/Task_Provider.dart';
import 'package:task_flow/Screens/Home/Home_Screen_UI.dart';
import '../Habits/Habit_Screen.dart';
import '../Profile/Profile_Screen.dart';
import '../Statistics/Statistics_Screen.dart';
import '../Tasks/Show_Tasks_Screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedItem = 0;
  List<Widget> screens = [
    HomeScreenUi(),
    ShowTasksScreen(),
    HabitScreen(),
    StatisticsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedItem,
            onTap: (value) {
              setState(() {
                selectedItem = value;
              });
            },
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.task_alt_rounded),
                label: "Tasks",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.monitor_heart_rounded),
                label: "Habits",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_rounded),
                label: "Stats",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_2_rounded),
                label: "Profile",
              ),
            ],
          ),
          body: screens[selectedItem],
        );
      },
    );
  }
}
