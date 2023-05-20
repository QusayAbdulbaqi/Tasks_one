import 'package:flutter/material.dart';
class TaskViewScreen extends StatefulWidget {
  const TaskViewScreen({Key? key}) : super(key: key);

  @override
  State<TaskViewScreen> createState() => _TaskViewScreenState();
}

List<Map<String, dynamic>> _allData = [];
class _TaskViewScreenState extends State<TaskViewScreen> {
  late String _description;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _description= ModalRoute.of(context)!.settings.arguments as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListTile(
          title:Text("Description:"+
            _description

          ),
        ),
      ),

    );
  }
}
