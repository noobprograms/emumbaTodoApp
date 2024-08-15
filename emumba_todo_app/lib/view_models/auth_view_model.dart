import 'dart:convert';
import 'dart:io';
import 'package:emumba_todo_app/models/task.dart';
import 'package:emumba_todo_app/utils/routes/routeNames.dart';
import 'package:emumba_todo_app/view_models/task_view_model.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

import 'package:emumba_todo_app/models/user.dart';
import 'package:emumba_todo_app/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class AuthViewModel extends ChangeNotifier{


    String _username = '';
  String _password = '';
  String _email = '';
  
    User myUser = User(id: '', username: '', email: '', password: '');

    User get user=>myUser;
    void setUser(String user){
      myUser = User.fromJson(user);
      print(myUser);
      notifyListeners();
  }


  String get username => _username;

  set username(String value) {
    _username = value;
    notifyListeners();
  }

  String get password => _password;

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  String get email => _email;

  set email(String value) {
    _email = value;
    notifyListeners();
  }






  //////////////////////////task stufff////////////////////////////////////
  ///
  List<Task> allTasks = [];
  List<Task> completed = [];
  List<Task> pending = [];

  String _newTaskName ="";
  String _newTaskDate = "";
  String _newTaskTime = "";
  bool timeWasUpdated = false;
  bool dateWasUpdated = false;
  bool _newTaskStatus = false;
  bool aiResponseWasGen = false;
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
  //////////////////////////task stuff end///////////////////////////////////////
  ///



  //functions for sign up and login 
  void signUpUser(BuildContext context)async{
    var myBaseUrl;
      if(Platform.isAndroid)
         myBaseUrl = "http://10.0.2.2:8712/users/";
        else myBaseUrl="${baseUrl}users/";
    try {
      // User user = User(id: '', username: username, token: '', role: role);
      print("the username is $_username the password is $_password and the email is $_email and the base url is $myBaseUrl");
      http.Response response = await http.post(Uri.parse("${myBaseUrl}registerUser"),headers: {'Content-Type': 'application/json; charset=UTF-8',},body: jsonEncode({'username':_username,'password':_password,'email':_email}) );
    
      if(response.statusCode==200){
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.check_circle),title: Text('$user added Successfully'),subtitle: Text('$_username added with email:$_email and password:$_password'),),),);
        print(response.body);
        SharedPreferences pref = await SharedPreferences.getInstance();
        setUser(jsonEncode(jsonDecode(response.body)['message']));
        var mylent = jsonDecode(response.body)["message"]['todos'].length;
        for(var i=0;i<mylent;i++){
          allTasks.add(Task.fromMap(jsonDecode(response.body)["message"]['todos'][i]));
            if(jsonDecode(response.body)["message"]['todos'][i]["completed"]){
              completed.add(Task.fromMap(jsonDecode(response.body)["message"]['todos'][i]));
            }else pending.add(Task.fromMap(jsonDecode(response.body)["message"]['todos'][i]));
        }
        await pref.setString('x-access-token', jsonDecode(response.body)['accessToken']);
        await pref.setString('x-refresh-token',jsonDecode(response.body)['refreshToken']);
        Navigator.pushReplacementNamed(context, RouteName.homeScreen);
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.dangerous_outlined),title: Text('Could not Sign Up'),subtitle: Text(jsonDecode(response.body)['message']),),),);
      }
    
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.dangerous_outlined),title: Text('Could not sign up'),subtitle: Text('$e'),),),);
      
    }

  }
  ///login service
  void login(BuildContext context) async{
    var myBaseUrl;
      if(Platform.isAndroid)
         myBaseUrl = "http://10.0.2.2:8712/users/";
        else myBaseUrl="${baseUrl}users/";
    try {
      // print('the username is $_username and the password is $_password');

      http.Response response = await http.post(Uri.parse("${myBaseUrl}signInUser",),headers: {'Content-Type': 'application/json; charset=UTF-8',},body: jsonEncode({'email':_email,'password':_password}));
      if(response.statusCode==200){

        SharedPreferences pref = await SharedPreferences.getInstance();

        setUser(jsonEncode(jsonDecode(response.body)['message']));
        print("after json decode this looks like this${jsonDecode(response.body)['message']["todos"]}");
        var mylent = jsonDecode(response.body)["message"]['todos'].length;
        for(var i=0;i<mylent;i++){
          allTasks.add(Task.fromMap(jsonDecode(response.body)["message"]['todos'][i]));
            if(jsonDecode(response.body)["message"]['todos'][i]["completed"]){
              completed.add(Task.fromMap(jsonDecode(response.body)["message"]['todos'][i]));
            }else pending.add(Task.fromMap(jsonDecode(response.body)["message"]['todos'][i]));
        }
        
        await pref.setString('x-access-token', jsonDecode(response.body)['accessToken']);
        await pref.setString('x-refresh-token',jsonDecode(response.body)['refreshToken']);
        
        Navigator.pushReplacementNamed(context, RouteName.homeScreen);
      }
      else {
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.dangerous_outlined),title: Text('Could not Login'),subtitle: Text(jsonDecode(response.body)['message']),),),);}
    } catch (e) {
      print("Login exception $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.dangerous_outlined),title: Text('Could not Login'),subtitle: Text('$e'),),),);

    }
    
  }



  //method to dispose the values of the provider
  void disposeAllValues(BuildContext context){
    allTasks = [];
    completed = [];
    pending = [];

    _newTaskName ="";
    _newTaskDate = "";
    _newTaskTime = "";
    _newTaskStatus = false;
    _selectedTime = TimeOfDay.now();
    _selectedDate = DateTime.now();
  }



  //logout service
  void signOutUser(BuildContext context)async{
    //logic to sign user out
      final navigator = Navigator.of(context);

      

      
      
      var myBaseUrl;
      if(Platform.isAndroid)
         myBaseUrl = "http://10.0.2.2:8712/users/";
        else myBaseUrl="${baseUrl}users/";

      
      try {
      // print('the username is $_username and the password is $_password');
        SharedPreferences pref = await SharedPreferences.getInstance();
        var myAccessToken = pref.getString('x-access-token');
        var myRefreshToken  = pref.getString('x-refresh-token');
        print("the refresh token provided is $myRefreshToken",);
        
      http.Response response = await http.delete(Uri.parse("${myBaseUrl}logoutUser",),headers: {'Content-Type': 'application/json; charset=UTF-8','Authorization': 'Bearer $myAccessToken',},body: jsonEncode({'refreshToken':myRefreshToken,}));
      if(response.statusCode==200){
        print(response.body);
        await pref.setString('x-access-token', '');
      await pref.setString('x-refresh-token', '');
        navigator.pushNamedAndRemoveUntil(RouteName.loginScreen, (route) => false);
        disposeAllValues(context);
      }
      else {
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.dangerous_outlined),title: Text('Could not logout'),subtitle: Text(jsonDecode(response.body)['message']),),),);}
    } catch (e) {
      print("Logout exception $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.dangerous_outlined),title: Text('Could not logout'),subtitle: Text('$e'),),),);

    }
      

  }





  ////////////////////////////the methods of the tasks////////////////////////////////////////
  ///
  //function to pick image 
  Future<XFile?> pickImage(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
        var myAccessToken = pref.getString('x-access-token');
    var myBaseUrl;
      if(Platform.isAndroid)
         myBaseUrl = "http://10.0.2.2:8712/tasks/photo/create";
        else myBaseUrl="${baseUrl}tasks/photo/create";
  XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
  var fileToUpload = File(file!.path);

  if (fileToUpload == null) {
    return null;
    
  }
  else {
    var request = new http.MultipartRequest("POST", Uri.parse(myBaseUrl));
    print('the path of the file is ${fileToUpload.path}');
    print('the access token is ${myAccessToken}');
    
    request.files.add(await http.MultipartFile.fromPath('image', fileToUpload.path,contentType: MediaType('image',"image")
                ));
    
      
    request.headers.addAll({"Authorization":'Bearer $myAccessToken',"Content-type":"multipart/form-data"});
    try{
      var response = await request.send().catchError((e)=>print(e));
      var myResponse =await  http.Response.fromStream(response);
      aiResponseWasGen = true;
      print('the response here is ');
      if(myResponse.statusCode==200){
      print('the response here is ');

        print("my response is ${jsonDecode(myResponse.body)['todos']}");
      var mylent = jsonDecode(myResponse.body)['todos'].length;
        for(var i=0;i<mylent;i++){
          allTasks.add(Task.fromMap(jsonDecode(myResponse.body)['todos'][i]));
            if(jsonDecode(myResponse.body)['todos'][i]["completed"]){
              completed.add(Task.fromMap(jsonDecode(myResponse.body)['todos'][i]));
            }else pending.add(Task.fromMap(jsonDecode(myResponse.body)['todos'][i]));
        }
        notifyListeners();

      }else
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.dangerous_outlined),title: Text('Could not add task from image'),subtitle: Text(jsonDecode(myResponse.body)['message']),),),);

      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.dangerous_outlined),title: Text('Error adding tasks from Image'),subtitle: Text('$e'),),),);

    }
  }
  
}
  ////////////////////////////////////the place where we can pick image//////////////////////////////////
  Future<void> addTask(BuildContext context) async{
    
    //TODO: create an api request here to get the response from the server
    //we need to first send the api request to the server so we get a completed todo and then we will add this todo to the alltasks list 
    //you also need to update the list of completed and the pending tasks
    SharedPreferences pref = await SharedPreferences.getInstance();
        var myAccessToken = pref.getString('x-access-token');
    var myBaseUrl;
      if(Platform.isAndroid)
         myBaseUrl = "http://10.0.2.2:8712/tasks/";
        else myBaseUrl="${baseUrl}tasks/";
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
        taskName="";
        _selectedTime = TimeOfDay.now();
    _selectedDate = DateTime.now();
        notifyListeners();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.check_circle),title: Text('Tasks added Successfully'),subtitle: Text('Success'),),),);
        print(allTasks);




      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.dangerous_outlined),title: Text('Could not add task'),subtitle: Text(jsonDecode(response.body)['message']),),),);
      }
        } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.dangerous_outlined),title: Text('Error adding task'),subtitle: Text('$e'),),),);
          
        }
    notifyListeners();

  }
  void updateTask(BuildContext context,Task myTask)async{
    var myObject = {};
    if(dateWasUpdated&&timeWasUpdated){
     myObject["taskName"] = taskName;
      myObject["date"] = "${selectedDate!.day}:${selectedDate!.month}:${selectedDate!.year}";
      myObject["time"] = "${selectedTime!.hour}:${selectedTime!.minute}:00";
      
    }else if(dateWasUpdated&&timeWasUpdated){
      myObject["taskName"] = taskName;
      myObject["date"] = "${selectedDate!.day}:${selectedDate!.month}:${selectedDate!.year}";


    }
    else if(timeWasUpdated){
      myObject["taskName"] = taskName;
      myObject["time"] = "${selectedTime!.hour}:${selectedTime!.minute}:00";
      
    }
    else{
      myObject["taskName"] = taskName;
    }


    SharedPreferences pref = await SharedPreferences.getInstance();
        var myAccessToken = pref.getString('x-access-token');
    var myBaseUrl;
      if(Platform.isAndroid)
         myBaseUrl = "http://10.0.2.2:8712/tasks/${myTask.id}";
        else myBaseUrl="${baseUrl}tasks/${myTask.id}";
   
    try {
          http.Response response = await http.put(Uri.parse("${myBaseUrl}"),headers: {'Content-Type': 'application/json; charset=UTF-8','Authorization': 'Bearer $myAccessToken'},body:jsonEncode(myObject) );
      
      if(response.statusCode==200){
        print(jsonDecode(response.body)['message']);
        int myIndex =allTasks.indexOf(myTask);
        myTask.taskName = taskName;
        myTask.date = myObject["date"]??myTask.date;
        myTask.time = myObject["time"]??myTask.time;
        print('the value of mytask here is $myTask');
        
        if(myTask.completed){


          completed.removeWhere((task)=>task.id ==myTask.id);
          completed.add(myTask);
        }else{


;
          pending.removeWhere((task)=>task.id==myTask.id);
          pending.add(myTask);
        }
        

        allTasks[myIndex] = myTask;
        notifyListeners();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.check_circle),title: Text('Task updated Successfully'),subtitle: Text('Success'),),),);
        print(allTasks);

         _selectedTime = TimeOfDay.now();
         _selectedDate = DateTime.now();
         timeWasUpdated = false;
         dateWasUpdated = false;
         taskName = "";


      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.dangerous_outlined),title: Text('Could not update task'),subtitle: Text(jsonDecode(response.body)['message']),),),);
      }
        } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.dangerous_outlined),title: Text('Error updating task'),subtitle: Text('$e'),),),);
          
        }

  }


   void markAsComplete(BuildContext context,Task myTask)async{
    
    

    
    SharedPreferences pref = await SharedPreferences.getInstance();
        var myAccessToken = pref.getString('x-access-token');
    var myBaseUrl;
      if(Platform.isAndroid)
         myBaseUrl = "http://10.0.2.2:8712/tasks/${myTask.id}";
        else myBaseUrl="${baseUrl}tasks/${myTask.id}";
   
    try {
          http.Response response = await http.put(Uri.parse("${myBaseUrl}"),headers: {'Content-Type': 'application/json; charset=UTF-8','Authorization': 'Bearer $myAccessToken'},body:jsonEncode({"completed":myTask.completed}) );
      
      if(response.statusCode==200){
        print(jsonDecode(response.body)['message']);
        int myIndex =allTasks.indexWhere((elem)=>myTask.id==elem.id);
        print(allTasks);

        print('the value of mytask here is $myTask');
        
        if(myTask.completed){
          myTask.completed = !myTask.completed;

          completed.removeWhere((task)=>task.id ==myTask.id);
          pending.add(myTask);
        }else{
        myTask.completed = !myTask.completed;

          print('i came inside the else block');
          pending.removeWhere((task)=>task.id==myTask.id);
          completed.add(myTask);
        }
        

        allTasks[myIndex] = myTask;
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.check_circle),title: Text('Task updated Successfully'),subtitle: Text('Success'),),),);
        print(allTasks);




      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.dangerous_outlined),title: Text('Could not update task'),subtitle: Text(jsonDecode(response.body)['message']),),),);
      }
        } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.dangerous_outlined),title: Text('Error updating task'),subtitle: Text('$e'),),),);
          
        }
    
    
  }


  void deleteTask(BuildContext context, String taskId)async{

    SharedPreferences pref = await SharedPreferences.getInstance();
        var myAccessToken = pref.getString('x-access-token');
    var myBaseUrl;
      if(Platform.isAndroid)
         myBaseUrl = "http://10.0.2.2:8712/tasks/${taskId}";
        else myBaseUrl="${baseUrl}tasks/${taskId}";
    try {
          http.Response response = await http.delete(Uri.parse("${myBaseUrl}"),headers: {'Content-Type': 'application/json; charset=UTF-8','Authorization': 'Bearer $myAccessToken'});
      
      if(response.statusCode==200){
        print(jsonDecode(response.body)['message']);
        

        
        
      

          completed.removeWhere((task)=>task.id ==taskId);

       
          pending.removeWhere((task)=>task.id==taskId);
          allTasks.removeWhere((task)=>task.id==taskId);
        
        
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.check_circle),title: Text('Task deleted Successfully'),subtitle: Text('Success'),),),);
        print(allTasks);




      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.dangerous_outlined),title: Text('Could not delete task'),subtitle: Text(jsonDecode(response.body)['message']),),),);
      }
        } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ListTile(leading: Icon(Icons.dangerous_outlined),title: Text('Error deleting task'),subtitle: Text('$e'),),),);
          
        }
  }

}