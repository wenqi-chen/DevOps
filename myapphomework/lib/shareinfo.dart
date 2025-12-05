// Flutter Todo App using GetX + SQLite (simple version)

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(TaskController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/todo',
      getPages: [
        GetPage(name: '/todo', page: () => TodoPage()),
        GetPage(name: '/add-task', page: () => AddTaskPage()),
      ],
    );
  }
}

// ------------------ MODEL ------------------
class TaskModel {
  int? id;
  String title;
  String date;

  TaskModel({this.id, required this.title, required this.date});

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'date': date,
      };

  factory TaskModel.fromMap(Map<String, dynamic> map) => TaskModel(
        id: map['id'],
        title: map['title'],
        date: map['date'],
      );
}

// ------------------ DATABASE ------------------
class TaskDB {
  static Database? _db;

  static Future<Database> db() async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'tasks.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE tasks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          date TEXT
        )
        ''');
      },
    );
  }

  static Future<int> insertTask(TaskModel task) async {
    final database = await db();
    return await database.insert('tasks', task.toMap());
  }

  static Future<List<TaskModel>> getTasks() async {
    final database = await db();
    final List<Map<String, dynamic>> maps = await database.query('tasks');
    return maps.map((e) => TaskModel.fromMap(e)).toList();
  }
}

// ------------------ CONTROLLER ------------------
class TaskController extends GetxController {
  var tasks = <TaskModel>[].obs;

  @override
  void onInit() {
    loadTasks();
    super.onInit();
  }

  Future<void> loadTasks() async {
    tasks.value = await TaskDB.getTasks();
  }

  Future<void> addTask(String title, String date) async {
    await TaskDB.insertTask(TaskModel(title: title, date: date));
    loadTasks();
  }
}

// ------------------ UI: TODO PAGE ------------------
class TodoPage extends StatelessWidget {
  final controller = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add-task'),
        child: Icon(Icons.add),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.tasks.length,
          itemBuilder: (context, index) {
            final t = controller.tasks[index];
            return Card(
              child: ListTile(
                title: Text(t.title),
                subtitle: Text(t.date),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ------------------ UI: ADD TASK PAGE ------------------
class AddTaskPage extends StatelessWidget {
  final controller = Get.find<TaskController>();
  final titleC = TextEditingController();
  final dateC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleC,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: dateC,
              decoration: InputDecoration(labelText: 'Date'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.addTask(titleC.text, dateC.text);
                Get.back();
              },
              child: Text('Add'),
            )
          ],
        ),
      ),
    );
  }
}
