import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:login/controllers/notifications/notifications.dart';
import 'package:login/shared/styles/colors.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;



class ScreenLogin extends StatefulWidget {
  const ScreenLogin({Key? key}) : super(key: key);

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {

  final _passwordController = TextEditingController();
  late  var _emailController = TextEditingController();
  @override
  void initState() {
    var fbm = FirebaseMessaging.instance;
    fbm.getToken().then((token) {
      print(
          "========================================================================");
      print(token);
      print(
          "=============================================================================");
    });
  }


  Future signIn() async{




    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),);



    Navigator.of(context).pushNamed('HomeTaskScreen');
  }
  void OpenSignupScreen() {
    Navigator.of(context).pushReplacementNamed('signupscreen');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool showSpinner = false;
 final formKey = GlobalKey<FormState>();
  final user =  FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: defaultColor[100],
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Center(
            child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Image.asset('assets/images/login1.png',
                        height: 170,
                      ),
                      SizedBox(height: 10,),
                      Text('Sign in',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Container(

                          decoration: BoxDecoration(
                            color: ConColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            //TextEditingController(text:user?.email??'')
                            child: TextFormField(
                              controller:_emailController = TextEditingController(text:user?.email??''),
                              decoration: InputDecoration(
                               // border: InputBorder.none,
                               labelText: 'Email',
                                // hintText:'Email',
                              ),
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'email must not be empty';
                                }
                                return null;
                              },
                            ),

                          ),
                        ),

                      ),
                      SizedBox(height: 15,),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Container(

                          decoration: BoxDecoration(
                            color: ConColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:'password',
                              ),
                              validator:(value){
                                if(value!.isEmpty){
                                  return 'password must not be empty';
                                }
                                return null;
                              },
                            ),

                          ),
                        ),

                      ),
                      SizedBox(height: 15,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: GestureDetector(
                          onTap: () {

                            if (formKey.currentState!.validate()) {
                              print(_emailController.text);
                              print(_passwordController.text);


                            };

                          },
                          onDoubleTap: signIn,
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: ButColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text('Sign in',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: ConColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Not a member?',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),
                          ),
                          GestureDetector(
                              onTap: OpenSignupScreen,
                              child: Text('Sgin up now',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: ButColor,
                                ),
                              )
                          )

                        ],
                      )


                    ],
                  ),
                )
            ),
          ),
        )


    );
  }
}

