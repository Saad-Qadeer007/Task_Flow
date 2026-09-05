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
                Text(
                  "Good Morning.",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight(400)),
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
                      color: AppColors.moderateGrey,
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            InkWell(
              onTap: () {
                // NotificationService().cancelAllNotification();
                print(provider.tasks.length);
              },
              child: Icon(
                Icons.notifications_none,
                size: 35,
                color: AppColors.moderateGrey,
              ),
            ),
          ],
        );
      },
    );
  }
}
