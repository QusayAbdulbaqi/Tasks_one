// import 'package:login/system/database_manger.dart';
//
// import '../models/task_model.dart';
//
// class TaskController {
//   List<Task> allTasks = [];
//   DBManager _dbManager = DBManager();
//
//
//   Task task = Task.empty();
//
//   Future<int> insertToTaskTable(Map<String, dynamic> row) async {
//     int result = await _dbManager.insertToDB("tasks", row);
//     return result;
//   }
//
//   Future<bool> updteTaskTable() async {
//     return true;
//   }
//
//   Future<bool> deleteTaskTable() async {
//     return true;
//   }
//
//   Future<void> showTasks() async {
//     List<Map<String, dynamic>> rows = await _dbManager.tableRows("tasks");
//     rows.forEach((element) {
//       Task task = Task(element);
//       print(task.title);
//
//       ;
//     });
//   }
// }
