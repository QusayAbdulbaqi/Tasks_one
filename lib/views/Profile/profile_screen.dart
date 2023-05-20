import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
File? imageFile;
final _nameController = TextEditingController();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();

class _ProfileScreenState extends State<ProfileScreen> {

  _showOption(BuildContext context){
    return showDialog(context:context,
        builder:(context)=> AlertDialog(

                title:Text('make a choice'),
                content:SingleChildScrollView(
                    child:Column(

                      children: [
                        ListTile(
                          leading:Icon(Icons.image),
                          title:Text('Gallery'),
                          onTap:()=>_imageFromGallery(context),

                        ),
                        ListTile(
                          leading:Icon(Icons.camera),
                          title:Text('Camera'),
                          onTap:()=>_imageFromCamera(context),

                        )
                      ],




                    )
                )

            )
    );
  }
  Future<void> _imageFromGallery(BuildContext context) async {
    final imagePicker = ImagePicker();
    final pickedFile =
    await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _imageFromCamera(BuildContext context) async {
    final imagePicker = ImagePicker();
    final pickedFile =
    await imagePicker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadPic(BuildContext context) async {
    if (imageFile != null) {
      final fileName = basename(imageFile!.path);
      final firebaseStorageRef =
      FirebaseStorage.instance.ref().child(fileName);
      final uploadTask = firebaseStorageRef.putFile(imageFile!);
      final snapshot = await uploadTask.whenComplete(() => null);
      final imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    }
    return null;
  }

  Future<void> _saveImagePath(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('imagePath', imagePath);
  }

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('imagePath');
    if (imagePath != null) {
      final image = File(imagePath);
      if (image.existsSync()) {
        setState(() {
          imageFile = image;
        });
      }
    }
  }

  final user = FirebaseAuth.instance.currentUser;



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
     appBar: AppBar(
       title: Text("Edit Profile"),
       backgroundColor: Colors.blueGrey[900],
       leading: IconButton

         (icon:
         Icon(Icons.arrow_back,
         color: Colors.amber,
         ),
           onPressed: (){
           Navigator.of(context).pop();
           },
       )
     ),
      body:Container(
        padding: EdgeInsets.only(left: 16,top: 25,right: 16),
        child: ListView(
          children: [

            Text('Edit Profile',style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            ),
            SizedBox(height: 10,),

            Center(
              child:GestureDetector(
                onTap: (){
                  _showOption(context);
                },
                child: Stack(
                  children: [
                    Container(
                      width:120 ,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.white24,
                        ),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 0.1,blurRadius: 2,
                            color:Colors.black,
                            offset: Offset(0,01),
                          ),
                        ],
                        shape: BoxShape.circle,
                        image: imageFile != null
                            ? DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(imageFile!),
                        )
                            : null,
                        )
                      ),
                    Positioned(
                    bottom: 0,
                        right: 0,
                        child:Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Colors.black,
                            ),
                            color:Colors.amber,
                          ),
                          child:Icon(
                            Icons.edit,
                            color: Colors.blueGrey[900],
                          ) ,
                        ),

                    )

                  ],

                ),
              ),
            ),
            SizedBox(height: 100,),
            TextField(
              controller: _nameController..text = user?.displayName ?? '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 4),
                labelText: "Name",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: 'Qusay',
                hintStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )
              ),
            ),
            SizedBox(height: 30,),
            TextField(
              controller: _emailController..text = user?.email ?? '',
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 4),
                  labelText: "Email",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText:user?.email??'',
                  hintStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )
              ),
            ),
            SizedBox(height: 30,),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 4),
                  labelText: "Password",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: '**************',
                  hintStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )
              ),
            ),
            SizedBox(height: 100,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(

                  onPressed: () async {
      final imageUrl = await _uploadPic(context);
      if (imageUrl != null) {
      await _saveImagePath(imageFile!.path);
      await user!.updateDisplayName(_nameController.text);
      await user?.updatePhotoURL(imageUrl);
      await user?.updateEmail(_emailController.text);
      await user?.updatePassword(_passwordController.text);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .set({
      'displayName': _nameController.text,
      'email': _emailController.text,
      'photoUrl': imageUrl,
      });
      Navigator.of(context).pop();

      }
      },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blueGrey[900],
                    ),
                  child: Text('Save',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.amber,



                  ),

                )
                ),
                ElevatedButton(


                    onPressed: () {
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueGrey[900],
                    ),
                    child: Text('Cancel',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.amber,



                      ),

                    )
                ),
              ],
            )


          ],
        ),
      ),


    );
  }
}
