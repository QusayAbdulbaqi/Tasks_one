


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/views/Home_task_screen.dart';
import 'package:login/views/Profile/profile_screen.dart';

import '../models/Login/screen_login.dart';
class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream:FirebaseAuth.instance.authStateChanges(),
        builder: ((context,snapshot) {
          if(!snapshot.hasData){
            return ScreenLogin();// HomeScreen();
          }else{
            return ScreenLogin();
          }
        }),
      ),
    );
  }
}
