import 'dart:io';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/auth_view_model.dart';

class ImageSelectionScreen extends StatelessWidget {
   ImageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
double screenWidth = MediaQuery.of(context).size.width;
     double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromRGBO(65, 107, 163, 1),Color.fromRGBO(73, 134, 188, 1),Color.fromRGBO(98, 144, 200, 1),Color.fromRGBO(130, 156, 188, 1)],
                begin: Alignment.bottomLeft,
                end:Alignment.topRight)),

        child: Padding(
              padding:  EdgeInsets.fromLTRB(screenWidth*0.08,screenHeight*0.08,screenWidth*0.08,8),
              child: Column(
                children: [Text("You can upload an image and our app will generate todos from that image. To try it, press the button below and select an image that has todos in it. Wait for some time for our app to process and you will be taken back to the home screen."),ElevatedButton(onPressed: ()async{
                                                await Provider.of<AuthViewModel>(context, listen: false)
                                                          .pickImage(context);

                                                if(!Provider.of<AuthViewModel>(context,listen: false).aiResponseWasGen){
                                                    await showDialog(context: context,builder:(context)=> AlertDialog(content:Container(width: 50,height: 100,child: CircularProgressIndicator(),)),);

                                                }else
                                                Navigator.pop(context);


                                              }, 
                                              
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Theme.of(context).primaryColor,
                                                  foregroundColor: Colors.white,),
                                                child:  Text("Create Task",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,fontSize: screenHeight*0.02),),),],
              ),
        ),
      ),
    );
  }
}