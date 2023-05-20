import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login/auth/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:login/views/Home_task_screen.dart';
import 'package:login/views/Profile/profile_screen.dart';
import 'package:login/views/task_view_screen.dart';
import 'models/HomeScreen/home_screen.dart';
import 'models/Login/screen_login.dart';
import 'models/SignUp/signup_screen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      // home: Auth(),
      routes: {
        '/': (context) =>const Auth(),
        'HomeTaskScreen': (context)=>const HomeTaskScreen(),
        'taskviewscreen': (context)=>const TaskViewScreen(),

        'homescreen': (context)=>const HomeScreen(),
        'signupscreen': (context)=>const SginUpScreen(),
        'loginscreen': (context)=>const ScreenLogin(),
        'profilescreen': (context)=>const ProfileScreen(),

      },
    );
  }
}

