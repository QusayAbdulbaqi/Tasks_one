import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:login/controllers/notifications/notifications.dart';
import 'package:login/views/MenuHome/menu_home.dart';
import '../system/database_manger.dart';
import 'package:http/http.dart' as http;

class HomeTaskScreen extends StatefulWidget {
  const HomeTaskScreen({Key? key}) : super(key: key);

  @override
  State<HomeTaskScreen> createState() => _HomeTaskScreenState();
}

class _HomeTaskScreenState extends State<HomeTaskScreen> {
  NotificationServices notificationServices = NotificationServices();


  List<Map<String, dynamic>> _allData = [];

  bool _isLoading = true;

  Future<void> _refreshData() async {
    final data = await DBManager.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }
  final user =  FirebaseAuth.instance.currentUser;



  @override
  void initState() {
    var fbm = FirebaseMessaging.instance;
    fbm.getToken().then((token)  {
      print("========================================================================");
      print(token);
      print("=============================================================================");
     // notificationServices.setupInteractMessage(context);
      notificationServices.getDeviceToken().then((value){

      });
    });

    _refreshData();
    super.initState();
  }

  Future<void> _addData() async {
    await DBManager.createData(_titleController.text, _descConttoller.text);

    _refreshData();
  }

  Future<void> _updateData(int id) async {
    await DBManager.updateData(id, _titleController.text, _descConttoller.text);
    _refreshData();
  }



  void _deleteData(int id) async {
    bool? deleteConfirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title:const Text("Delete Data"),
        content: const Text("Are you sure you want to delete this data?",
        ),
        actions: [
          TextButton(
            child:const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child:const Text("Delete",
              style: TextStyle(
                  color: Colors.red
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
    if (deleteConfirmed != null && deleteConfirmed) {
      await DBManager.deleteData(id);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
           backgroundColor: Colors.red,
        content: Text("Data Deleted"),
      ));
      _refreshData();
    }
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descConttoller = TextEditingController();

  void showAlertDialog(int? id) async {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _titleController.text = existingData['title'];
      _descConttoller.text = existingData['description'];
    }
    showDialog(
        // isScrollControlled: true,
        context: context,
        builder: (_) => Center(
              child: SingleChildScrollView(
                  child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                content: Container(
                  // height: 400,
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    top: 10,
                    left: 10,
                    right: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration:const InputDecoration(
                            border: OutlineInputBorder(), hintText: "Title"),
                      ),
                     const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _descConttoller,
                        decoration:const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Description"),
                      ),
                  const    SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (id == null) {
                              await _addData();
                            }
                            if (id != null) {
                              await _updateData(id);
                            }



                            _titleController.text = "";
                            _descConttoller.text = "";
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding:const EdgeInsets.all(18),
                            child: Text(
                              id == null ? "Add Data" : "Update",
                              style:const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      drawer:const MenuHome(),
      appBar: AppBar(
        title:const Text("Home"),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: LiquidPullToRefresh(
        backgroundColor: Colors.blueGrey[900],
        color: Colors.amber,
        showChildOpacityTransition: false,
        onRefresh: _refreshData,
        child: ListView.builder(
          itemCount: _allData.length,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                'taskviewscreen',
                arguments: _allData[index]['description']

              );
            },
            child: Card(
              margin:const EdgeInsets.all(5),
              child: ListTile(
                title: Padding(
                  padding:const EdgeInsets.symmetric(vertical: 3),
                  child: Text(
                    _allData[index]['title'],
                    style:const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                //subtitle: Text(_allData[index]['description']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          showAlertDialog(_allData[index]['id']);
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.blueGrey[900],
                        )),
                    IconButton(
                        onPressed: () {
                          _deleteData(_allData[index]['id']);

                        },
                        icon:const Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() => showAlertDialog(null)),
        child: Icon(
          Icons.add,
          color: Colors.amber,
        ),
        backgroundColor: Colors.blueGrey[900],
      ),
    );
  }
}
