import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Utilties/App_Colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
                                  FirebaseAuth.instance.currentUser!.displayName
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
                SizedBox(height: 20),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
