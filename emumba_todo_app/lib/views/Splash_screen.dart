import 'dart:async';

import 'package:emumba_todo_app/utils/constants/imageConstants.dart';
import 'package:emumba_todo_app/utils/routes/routeNames.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {
  
  @override 
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () { 
      Navigator.pushReplacementNamed(context, RouteName.loginScreen);
    });
  }
  
  @override
  Widget build(BuildContext context) {
     double screenWidth = MediaQuery.of(context).size.width;
     double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(gradient: LinearGradient(              colors: [Color.fromRGBO(29, 52, 97, 1),Color.fromRGBO(31, 72, 126, 1),Color.fromRGBO(55,105,150,1),Color.fromRGBO(98, 144, 200, 1),Color.fromRGBO(130, 156, 188, 1)],
begin: Alignment.topLeft,end:Alignment.bottomRight)),
        child: Center(
          child: Container(
            width:screenWidth*0.4,
            height: screenHeight*0.17,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(ImageConstants.splashLogo),
                fit: BoxFit.fill)),
                child: SizedBox(width: 20,height: 20,),),),
        ),
    );
  }
}