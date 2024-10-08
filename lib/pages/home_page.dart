import 'package:app_to_do/data/database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive/hive.dart';
import '../util/dialog_box.dart';
import '../util/todo_tile.dart'; // Ensure you have this file for TodoTile


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //reference hive box
  final _myBox = Hive.box("mybox");
  ToDoDatabase db = ToDoDatabase();
  @override
  void initState(){

    // if this is the first time ever opening the app then create default data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    }
    else{
      //if they exist data
      db.loadData();
    }
    super.initState();
  }
  // Text controller for user input
  final _controller = TextEditingController();

  // // List of to-do tasks as a list of lists
  // List<List<dynamic>> toDoList = [
  //   ["Make Tutorial", false],
  //   ["Complete Homework", false],
  // ];

  // Checkbox tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = value!; // Update task completion status
    });
    db.updateDatabase();
  }

  // Save new task
  void saveNewTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        db.toDoList.add([_controller.text, false]); // Add new task
        _controller.clear(); // Clear the text field
      });
      Navigator.of(context).pop();
      db.updateDatabase();// Close the dialog
    }
  }

  // Create new task dialog
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  //delete task
  void deleteTask(int index){
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Center(
          child: Text("TO DO"),
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          var task = db.toDoList[index];
          return TodoTile(
            taskName: task[0], // Access task name
            taskCompleted: task[1], // Access completion status
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask( index),
          );
        },
      ),
    );
  }
}
