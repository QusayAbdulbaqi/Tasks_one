
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/controllers/notifications/notifications.dart';
import '../../shared/styles/colors.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class SginUpScreen extends StatefulWidget {
  const SginUpScreen({Key? key}) : super(key: key);

  @override
  State<SginUpScreen> createState() => _SginUpScreenState();
}

class _SginUpScreenState extends State<SginUpScreen> {


  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  NotificationServices notificationServices = NotificationServices();

  Future signUp() async {
    if (passwordConfirmed()) {
      var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (result != null) {
        FirebaseFirestore.instance.collection('users').doc(result.user!.uid).set({
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),


        });
      }

      // FirebaseFirestore.instance.collection("Users").add({
      //   "email":_emailController.text.trim(),
      //   "password":_passwordController.text.trim(),
      //
      // });

      Navigator.of(context).pushNamed('loginscreen');

    }
  }
  bool passwordConfirmed(){
    if(_passwordController.text.trim()==
    _confirmPasswordController.text.trim()) {
      return true;
    }else
    {
      return false;
    }
    }


  void OpenSignupScreen(){

    Navigator.of(context).pushReplacementNamed('loginscreen');

  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool showSpinner = false;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: SignupColor[100],
        body: Form(
        key:formKey,
          child: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset('assets/images/add-user.png',
                      height: 120,
                    ),
                    SizedBox(height: 10,),
                  const  Text('Sign Up',
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
                            child:TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Email',
                                  prefixIcon: Icon(
                                    Icons.email,

                                  ),
                                ),
                                validator: (value){
                                  if(value!.isEmpty ||RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                                    return "enter  correct email [@ ,134,.]";
                                  }else if(value.isEmpty){
                                    return 'Confirm password must not be empty';
                                  }
                                  return null;

                                }
                            ),
                          )
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(

                        decoration: BoxDecoration(
                          color: ConColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child:TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                                prefixIcon: Icon(
                                  Icons.password_outlined,

                                ),
                                suffixIcon: Icon(
                                  Icons.remove_red_eye,
                                )
                            ),
                            validator:(value){
                              if(value!.isEmpty){
                                return 'password must not be empty';
                              }
                              return null;
                            },
                          ) ,

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
                          child:TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Confirm Password',
                               prefixIcon: Icon(
                                 Icons.password_outlined,

                               ),
                              suffixIcon: Icon(
                                Icons.remove_red_eye,
                              )
                            ),
                            validator:(value){
                              if(value!.isEmpty){
                                return 'Confirm password must not be empty';
                              }else if(_passwordController.text.trim()!=
                                  _confirmPasswordController.text.trim()){
                                return 'Not Confirm password ';
                              }
                              return null;
                            },
                          ) ,

                        ),
                      ),

                    ),
                    SizedBox(height: 15,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child:GestureDetector(
                        onTap: ()async{
                          if(formKey.currentState!.validate()){
                          var result = await   FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);

                            print(_emailController.text);
                            print(_passwordController.text);
                            print(_confirmPasswordController.text);
                          }
                        },
                        onDoubleTap: signUp,
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: ButColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text('Create',
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
                        Text('Already a member?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),
                        ),
                        GestureDetector(
                            onTap:OpenSignupScreen,
                            child:  Text('Sgin in here',
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
              ),
            ),
          ),
        )
    );
  }
}
