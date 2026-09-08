import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/Provider/Task_Provider.dart';
import '../Utilties/App_Colors.dart';

class GreetingCard extends StatefulWidget {
  const GreetingCard({super.key});

  @override
  State<GreetingCard> createState() => _GreetingCardState();
}

class _GreetingCardState extends State<GreetingCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      provider.greeting,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight(400),
                      ),
                    ),
                    SizedBox(width: 10),
                    provider.greeting.toLowerCase() == "good morning"
                        ? Icon(
                            Icons.sunny,
                            size: 20,
                            color: provider.isDark
                                ? AppColors.lightColor
                                : AppColors.moderateGrey,
                          )
                        : provider.greeting.toLowerCase() == "good night"
                        ? FaIcon(
                            FontAwesomeIcons.moon,
                            size: 20,
                            color: provider.isDark
                                ? AppColors.lightColor
                                : AppColors.moderateGrey,
                          )
                        : provider.greeting.toLowerCase() == "good evening"
                        ? FaIcon(
                            FontAwesomeIcons.eyeLowVision,
                            size: 20,
                            color: provider.isDark
                                ? AppColors.lightColor
                                : AppColors.moderateGrey,
                          )
                        : Icon(
                            Icons.sunny,
                            size: 20,
                            color: provider.isDark
                                ? AppColors.lightColor
                                : AppColors.moderateGrey,
                          ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      FirebaseAuth.instance.currentUser!.displayName
                              .toString()[0]
                              .toUpperCase() +
                          FirebaseAuth.instance.currentUser!.displayName
                              .toString()
                              .substring(1),
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight(400),
                      ),
                    ),
                    SizedBox(width: 10),
                    FaIcon(
                      FontAwesomeIcons.user,
                      size: 25,
                      color: provider.isDark
                          ? AppColors.lightColor
                          : AppColors.moderateGrey,
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            InkWell(
              // onTap: () {
              //   showDialog(
              //     context: context,
              //     builder: (context) => AlertDialog(
              //       title: Text(
              //         "Notification Viewer",
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           fontSize: 18,
              //         ),
              //       ),
              //       content: Column(
              //         mainAxisSize: MainAxisSize.min,
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [Text("Coming Soon...")],
              //       ),
              //       actions: [
              //         ElevatedButton(
              //           onPressed: () {
              //             Navigator.pop(context);
              //           },
              //           style: ElevatedButton.styleFrom(
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(10),
              //             ),
              //             foregroundColor: AppColors.lightColor,
              //             backgroundColor: AppColors.primaryColor,
              //           ),
              //           child: Text("Close"),
              //         ),
              //       ],
              //     ),
              //   );
              // },
              onTap: () {
                print(provider.tasks.length);
                print(provider.notNullTodayTaskCount);
                print(provider.notNullUpcomingTaskCount);
                print(provider.filteredList.length);
              },
              child: Icon(
                Icons.notifications_none,
                size: 35,
                color: provider.isDark
                    ? AppColors.lightColor
                    : AppColors.moderateGrey,
              ),
            ),
          ],
        );
      },
    );
  }
}
