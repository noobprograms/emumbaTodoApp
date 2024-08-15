import 'package:emumba_todo_app/utils/routes/routeNames.dart';
import 'package:emumba_todo_app/views/Home_screen.dart';
import 'package:emumba_todo_app/views/Login_screen.dart';
import 'package:emumba_todo_app/views/Register_screen.dart';
import 'package:emumba_todo_app/views/Splash_screen.dart';
import 'package:emumba_todo_app/views/completed_screen.dart';
import 'package:emumba_todo_app/views/image_selection_screen.dart';
import 'package:emumba_todo_app/views/pending_screen.dart';
import 'package:flutter/material.dart';

class Routes{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case RouteName.splashScreen:
        return MaterialPageRoute(builder: (context)=>const SplashScreen());
        
      case RouteName.loginScreen:
        return MaterialPageRoute(builder: (context)=> LoginScreen());
      case RouteName.registerScreen:
        return MaterialPageRoute(builder: (context)=> RegisterScreen());
      case RouteName.homeScreen:
        return MaterialPageRoute(builder: (context)=>const HomeScreen());
      case RouteName.imageSelectionScreen:
        return MaterialPageRoute(builder: (context)=> ImageSelectionScreen());
      case RouteName.completedScreen:
        return MaterialPageRoute(builder: (context)=> CompletedScreen());
      case RouteName.pendingScreen:
        return MaterialPageRoute(builder: (context)=> PendingScreen());

      default:
        return MaterialPageRoute(builder: (context)=>Scaffold(body: Center(child: Text("wrong route dude!!!"),),));
    }
  }
}