import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_flow/Screens/Auth/Login_Screen.dart';
import 'package:task_flow/Utilties/App_Theme.dart';
import 'Screens/Auth/Splash_Screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme().lightTheme,
      themeMode: ThemeMode.light,
      home: SplashScreen(),
    );
  }
}
