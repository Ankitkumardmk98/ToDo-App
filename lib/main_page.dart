import 'package:flutter/material.dart';
import 'constant.dart';

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

// Function to show the alert
  void _showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete All"),
          content: Text("Do You want to delete all your tasks?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteAllTask();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
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
              child: Text(
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
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }

//Empty List for Tasks
  List<Task> taskList = [];

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
        userInput.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140),
        child: AppBar(
          backgroundColor: appbarBgColor,
          title: Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 10,
              right: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ToDo App",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: () {
                    _showAlert(context);
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(30),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search Your Tasks",
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
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
          SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                style: TextStyle(color: grey),
                controller: userInput,
                decoration: InputDecoration(
                  hintText: "Add Your Task",
                  hintStyle: TextStyle(
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
              icon: Icon(
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
