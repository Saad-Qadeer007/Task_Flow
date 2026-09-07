import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/Provider/Task_Provider.dart';
import 'package:task_flow/Screens/Habits/Habit_Screen.dart';
import '../../Utilties/App_Colors.dart';
import '../../Widgets/Profile_Card.dart';
import '../Auth/Login_Screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool settingsController = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.secondaryTextColor,
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: AppColors.lightColor,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            FirebaseAuth.instance.currentUser!.displayName
                                        .toString() ==
                                    ""
                                ? "No Name"
                                : FirebaseAuth.instance.currentUser!.displayName
                                          .toString()[0]
                                          .toUpperCase() +
                                      FirebaseAuth
                                          .instance
                                          .currentUser!
                                          .displayName
                                          .toString()
                                          .substring(1),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            FirebaseAuth.instance.currentUser!.email.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.moderateGrey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Divider(),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HabitScreen(),
                          ),
                        );
                      },
                      child: ProfileCard(
                        title: "My Habits",
                        icon: Icons.bar_chart_rounded,
                      ),
                    ),
                    SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        setState(() {
                          settingsController = !settingsController;
                        });
                      },
                      child: ProfileCard(
                        title: "Settings",
                        icon: Icons.settings_rounded,
                      ),
                    ),
                    settingsController == true
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: provider.isDark == false
                                    ? AppColors.cards
                                    : AppColors.moderateGrey,
                                border: Border.all(
                                  color: provider.isDark
                                      ? AppColors.darkBackground
                                      : Colors.grey.shade300,
                                  width: .9,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SwitchListTile(
                                    title: Text(
                                      "Dark Mode",
                                      style: TextStyle(
                                        color: provider.isDark == false
                                            ? AppColors.moderateGrey
                                            : AppColors.lightColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    value: provider.isDark,
                                    onChanged: (bool value) {
                                      provider.toggleDarkMode();
                                    },
                                  ),
                                  SwitchListTile(
                                    title: Text(
                                      "Notifications",
                                      style: TextStyle(
                                        color: provider.isDark == false
                                            ? AppColors.moderateGrey
                                            : AppColors.lightColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    value: provider.isNotification,
                                    onChanged: (bool value) {
                                      provider.toggleNotification();
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Divider(),
                                          Text(
                                            "About",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text("Version"),
                                              Spacer(),
                                              Text("1.0.0"),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).animate().fade().slideX(
                            begin: 0.5,
                            end: 0,
                            duration: 500.ms,
                          )
                        : SizedBox(),
                    SizedBox(height: 15),
                    ProfileCard(title: "Help", icon: Icons.help_rounded),
                    SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              "About",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "This is a simple habit tracking app which lets you track your tasks and habits and track your progress.",
                                  style: TextStyle(
                                    color: provider.isDark == false
                                        ? AppColors.moderateGrey
                                        : AppColors.lightColor,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  "Build With Flutter",
                                  style: TextStyle(
                                    color: AppColors.moderateGrey,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  "Powered By Firebase",
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      8,
                                    ),
                                  ),
                                  foregroundColor: AppColors.lightColor,
                                  backgroundColor: AppColors.primaryColor,
                                ),
                                child: Text("Close"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: ProfileCard(
                        title: "About",
                        icon: Icons.info_rounded,
                      ),
                    ),

                    SizedBox(height: 30),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              "Logout",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Are U Sure You Want To Logout?",
                                  style: TextStyle(
                                    color: provider.isDark == false
                                        ? AppColors.moderateGrey
                                        : AppColors.lightColor,
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
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: Text("Logout"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.cards,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: .9,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout_rounded,
                                color: AppColors.errorColor,
                                size: 30,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Logout",
                                style: TextStyle(
                                  color: AppColors.errorColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
