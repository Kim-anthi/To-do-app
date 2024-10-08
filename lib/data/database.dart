import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase{
  List toDoList = [];
  //reference the box
  final _myBox = Hive.box("myBox");


// for first time opening the app
  void createInitialData(){
    toDoList = [
      ["Make Tutorial", false],
      ["Do Exercise", false],

    ];

  }
  // load data from database
  void loadData(){
    toDoList = _myBox.get("TODOLIST");

  }
  //update the database
  void updateDatabase(){
    _myBox.put("TODOLIST", toDoList);

  }


}