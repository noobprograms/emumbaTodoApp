
import 'dart:convert';
import 'dart:io';


import 'package:emumba_todo_app/models/task.dart';
import 'package:emumba_todo_app/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class TaskViewModel with ChangeNotifier {
  List<Task> allTasks = [];
  List<Task> completed = [];
  List<Task> pending = [];

  String _newTaskName ="";
  String _newTaskDate = "";
  String _newTaskTime = "";
  bool _newTaskStatus = false;
  TimeOfDay? _selectedTime = TimeOfDay.now();
  DateTime? _selectedDate = DateTime.now();
  String get taskName => _newTaskName;
  String get taskDate => _newTaskDate;
  String get taskTime => _newTaskTime;
  bool get taskStatus => _newTaskStatus;

  TimeOfDay? get selectedTime =>_selectedTime;
  DateTime? get selectedDate =>_selectedDate;

  set taskName(String value) {
    _newTaskName = value;
    notifyListeners();
  }
  set taskTime(String value) {
    _newTaskTime = value;
    notifyListeners();
  }
  set taskDate(String value) {
    _newTaskDate = value;
    notifyListeners();
  }
  set taskStatus(bool value) {
    _newTaskStatus = value;
    notifyListeners();
  }

  set selectedDate(DateTime? value) {
    _selectedDate = value;
    notifyListeners();
  }
  set selectedTime(TimeOfDay? value) {
    _selectedTime = value;
    notifyListeners();
  }




 
  void getAllTasks(BuildContext context)async{
    print(allTasks);
    SharedPreferences pref = await SharedPreferences.getInstance();
        var myAccessToken = pref.getString('x-access-token');
    var myBaseUrl;
      if(Platform.isAndroid)
         myBaseUrl = "http://10.0.2.2:8712/tasks/";
        else myBaseUrl="${baseUrl}tasks/";
    try {
      // User user = User(id: '', username: username, token: '', role: role);

      http.Response response = await http.get(Uri.parse("${myBaseUrl}"),headers: {'Content-Type': 'application/json; charset=UTF-8','Authorization': 'Bearer $myAccessToken'} );
      
      if(response.statusCode==200){
       var mylent = jsonDecode(response.body)['todos'].length;
        for(var i=0;i<mylent;i++){
          print(jsonDecode(response.body)['todos'][i].runtimeType);
          allTasks.add(Task.fromMap(jsonDecode(response.body)['todos'][i]));
          if(jsonDecode(response.body)['todos'][i]["completed"]){
            completed.add(Task.fromMap(jsonDecode(response.body)['todos'][i]));
          }else pending.add(Task.fromMap(jsonDecode(response.body)['todos'][i]));
        }
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.check_circle),title: Text('Tasks loaded Successfully'),subtitle: Text('Success'),),),);
        print(allTasks);



      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.dangerous_outlined),title: Text('Could not load tasks'),subtitle: Text(jsonDecode(response.body)['message']),),),);
      }
    
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.dangerous_outlined),title: Text('Could not load tasks'),subtitle: Text('$e'),),),);
      
    }
  }


  

  void addTask(BuildContext context) async{
    
    //TODO: create an api request here to get the response from the server
    //we need to first send the api request to the server so we get a completed todo and then we will add this todo to the alltasks list 
    //you also need to update the list of completed and the pending tasks
    SharedPreferences pref = await SharedPreferences.getInstance();
        var myAccessToken = pref.getString('x-access-token');
    var myBaseUrl;
      if(Platform.isAndroid)
         myBaseUrl = "http://10.0.2.2:8712/tasks/task";
        else myBaseUrl="${baseUrl}tasks/task";
        try {
          http.Response response = await http.post(Uri.parse("${myBaseUrl}"),headers: {'Content-Type': 'application/json; charset=UTF-8','Authorization': 'Bearer $myAccessToken'},body:jsonEncode({"taskName":taskName,"time":"${selectedTime!.hour}:${selectedTime!.minute}:00","date":'${selectedDate!.day}:${selectedDate!.month}:${selectedDate!.year}',"completed":taskStatus}) );
      
      if(response.statusCode==200){
        print(jsonDecode(response.body)['task']);
       var myTask = Task.fromMap(jsonDecode(response.body)['task']);
        allTasks.add(myTask);
        if(myTask.completed){
          completed.add(myTask);
        }else{
          pending.add(myTask);
        }
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.check_circle),title: Text('Tasks added Successfully'),subtitle: Text('Success'),),),);
        print(allTasks);




      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.dangerous_outlined),title: Text('Could not add task'),subtitle: Text(jsonDecode(response.body)['message']),),),);
      }
        } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.dangerous_outlined),title: Text('Could not add task'),subtitle: Text('$e'),),),);
          
        }
    notifyListeners();

  }

  //when a user presses a checkbox change the value of that task completed in the alltasks//
  //fetch that task's id from its object and pop it from pending/complete and push to complete/pending respectively
  //using this id add the complete:true/complete:false value to a payload and send it to the servers update task route
  void markAsComplete(BuildContext context,Task myTask)async{
    int myIndex =allTasks.indexOf(myTask);
    allTasks.removeAt(myIndex);
    if(myTask.completed){
      completed.remove(myTask);
      myTask.completed = !myTask.completed;
      allTasks[myIndex] = myTask;
      pending.add(myTask);
    }else{
      pending.remove(myTask);

      myTask.completed = !myTask.completed;
      allTasks[myIndex] = myTask;
      completed.add(myTask);
    }
    
    
    notifyListeners();
  }

}