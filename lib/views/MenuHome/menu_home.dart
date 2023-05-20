

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenuHome extends StatefulWidget {

  const MenuHome({Key? key}) : super(key: key);

  @override
  State<MenuHome> createState() => _MenuHomeState();
}

class _MenuHomeState extends State<MenuHome> {
  File? imageFile;

  final user =  FirebaseAuth.instance.currentUser;
  String imageUrl = "https://firebasestorage.googleapis.com/v0/b/login-9f81c.appspot.com/o/PhotoShot_1682591283745.jpg?alt=media&token=c3dc007b-962b-4aac-933c-a1593848cfe1";
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blueGrey[900],
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pushNamed('profilescreen');
                },
                child: UserAccountsDrawerHeader(
                  accountName: Text('',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[900],
                    ),),
                  accountEmail: Text(user?.email??'',style: TextStyle(
                    color: Colors.black,
                    fontWeight:FontWeight.bold,
                    fontSize: 15,
                  ),),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                        // Image.file(imageFile!),
                      child:Image.network(
                        imageUrl,
                      width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )


                    ),
                  ),
                  decoration: BoxDecoration(

                    color: Colors.grey[400],
                  ),
                ),
              ),

            ],
          ),

          ListTile(
            leading: Icon(Icons.home,color: Colors.amber[400],size: 30,),
            title: Text('Home',style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[400],
            ),),
            onTap: (){}
          ),
          ListTile(
            leading: Icon(Icons.settings,color: Colors.amber[400],size: 30),
            title: Text('Settings',style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[400],
            ),),
            onTap: ()=>null,
          ),
          ListTile(
            leading: Icon(Icons.accessibility_new_rounded,color: Colors.amber[400],size: 30),
            title: Text('ِِِAround',style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[400],
            ),),
            onTap: (){}
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app,color: Colors.amber[400],size: 30),
            title: Text('Log out',style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[400],
            ),
            ),
            onTap: (){
              Navigator.of(context).pushNamed('loginscreen');
            }
          ),
        ],
      ),
    );
  }
}
