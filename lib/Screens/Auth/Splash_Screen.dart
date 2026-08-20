import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/Provider/Task_Provider.dart';
import 'package:task_flow/Screens/Home/Home_Screen.dart';
import '../../Utilties/App_Colors.dart';
import 'Login_Screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeApp();
  }

  void initializeApp() async {
    context.read<TaskProvider>().getTasks();
    Future.delayed(Duration(seconds: 3), () {
      print(FirebaseAuth.instance.currentUser?.displayName);
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }


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
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight(550),
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Text(
            "Plan. Focus. Achieve.",
            style: TextStyle(color: AppColors.moderateGrey, fontSize: 22),
          ),
          SizedBox(height: 50),
          CircularProgressIndicator(color: AppColors.primaryColor),
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
