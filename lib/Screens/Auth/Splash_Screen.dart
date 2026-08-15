import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Utilties/App_Colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //   Logo
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: CircleAvatar(
                backgroundColor: AppColors.lightColor,
                radius: 45,
                child: Icon(
                  Icons.done_rounded,
                  color: AppColors.primaryColor,
                  size: 80,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "TaskFlow",
                style: TextStyle(fontSize: 60,
                    fontWeight: FontWeight(550),
                    color: AppColors.textPrimary),
              ),
            ],
          ),
          Text(
            "Plan. Focus. Achieve.",
            style: TextStyle(color: AppColors.moderateGrey, fontSize: 22),
          ),
          SizedBox(height: 50),
          CircularProgressIndicator(color: AppColors.primaryColor,),
          SizedBox(height: 20),
          Text(
            "Loading...",
            style: TextStyle(color: Colors.grey.shade700, fontSize: 25),
          ),
        ],
      ),
    );
  }
}
