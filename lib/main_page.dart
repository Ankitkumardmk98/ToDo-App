import 'package:flutter/material.dart';
import 'constant.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

//Creating a class
class Task {
  String taskTitle;
  bool isDone;

  Task({
    required this.taskTitle,
    this.isDone = false,
  });
}

class _MainPageState extends State<MainPage> {
  TextEditingController userInput = TextEditingController();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initNotifications() {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings settings =
        const InitializationSettings(android: androidSettings);

    flutterLocalNotificationsPlugin.initialize(settings);
  }

  Future<void> showNotification(String taskTitle) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'task_channel',
      'Task Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'New Task Added',
      taskTitle,
      notificationDetails,
    );
  }

// Function to show the alert
  void _showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete All"),
          content: const Text("Do You want to delete all your tasks?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteAllTask();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "All Tasks are cleared now",
                      style: TextStyle(
                        color: black,
                      ),
                    ),
                    showCloseIcon: true,
                    closeIconColor: black,
                    duration: Duration(seconds: 2),
                    backgroundColor: appbarBgColor,
                  ),
                );
              },
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: red,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

//Empty List for Tasks
  List<Task> taskList = <Task>[];

//Function to delete all tasks
  void deleteAllTask() {
    setState(() {
      taskList.clear();
    });
  }

//Function to add tasks
  void addTask() {
    if (userInput.text.isNotEmpty) {
      taskList.add(
        Task(taskTitle: userInput.text),
      );
      setState(() {
        showNotification(userInput.text);
        userInput.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please add any task",
            style: TextStyle(
              color: black,
            ),
          ),
          showCloseIcon: true,
          closeIconColor: black,
          duration: Duration(seconds: 2),
          backgroundColor: appbarBgColor,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: AppBar(
          backgroundColor: appbarBgColor,
          title: Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 10,
              right: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  "ToDo App",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: () {
                    _showAlert(context);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search Your Tasks",
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: taskList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    taskList[index].taskTitle,
                    style: TextStyle(
                      color: taskList[index].isDone ? green : grey,
                      decoration: taskList[index].isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      taskList[index].isDone
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: grey,
                    ),
                    onPressed: () {
                      setState(() {
                        taskList[index].isDone = !taskList[index].isDone;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                style: const TextStyle(color: grey),
                controller: userInput,
                decoration: InputDecoration(
                  hintText: "Add Your Task",
                  hintStyle: const TextStyle(
                    color: grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: addTask,
              icon: const Icon(
                Icons.add,
                color: grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
