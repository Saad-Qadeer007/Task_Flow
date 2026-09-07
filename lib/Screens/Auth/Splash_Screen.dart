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

  Future<void> initializeApp() async {
    await context.read<TaskProvider>().getTasks();

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

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
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
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
                      fontWeight: FontWeight.w500,
                      color: provider.isDark
                          ? AppColors.lightColor
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                "Plan. Focus. Achieve.",
                style: TextStyle(
                  color: provider.isDark
                      ? AppColors.lightColor
                      : AppColors.moderateGrey,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 50),
              CircularProgressIndicator(
                color: provider.isDark
                    ? AppColors.lightColor
                    : AppColors.primaryColor,
              ),
              SizedBox(height: 20),
              Text(
                "Loading...",
                style: TextStyle(
                  color: provider.isDark
                      ? AppColors.lightColor
                      : AppColors.moderateGrey,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
