import 'package:emumba_todo_app/utils/constants/imageConstants.dart';
import 'package:emumba_todo_app/utils/routes/routeNames.dart';
import 'package:emumba_todo_app/view_models/auth_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
   RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      
        child: Scaffold(extendBodyBehindAppBar: true,appBar: AppBar(automaticallyImplyLeading: false,

        backgroundColor: Colors.transparent,),
        body: Container(
          width: screenWidth,
          height: screenHeight,

          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromRGBO(29, 52, 97, 1),Color.fromRGBO(31, 72, 126, 1),Color.fromRGBO(55,105,150,1),Color.fromRGBO(98, 144, 200, 1),Color.fromRGBO(130, 156, 188, 1)],
              begin: Alignment.bottomLeft,
              end:Alignment.topRight)), 
                child: Column(
          children: [
            SizedBox(height: screenHeight*0.1,),
            Container(
              width:screenWidth*0.35,
              height: screenHeight*0.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage(ImageConstants.splashLogo),
                  fit: BoxFit.fill)),
            ),
            SizedBox(height: screenHeight*0.1,),
            Container(
              width: screenWidth*0.8,
              decoration: BoxDecoration(color: const Color.fromARGB(76, 217, 217, 217),borderRadius: BorderRadius.circular(10)),


              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: TextField(
                  controller: widget.usernameController,
                  onChanged: (value) =>
                      Provider.of<AuthViewModel>(context, listen: false)
                          .username = value,
                  decoration: const InputDecoration(
                    hintText: "Username",
                    border: InputBorder.none
                
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight*0.05,),
            Container(
              width: screenWidth*0.8,
              decoration: BoxDecoration(color: const Color.fromARGB(76, 217, 217, 217),borderRadius: BorderRadius.circular(10),),


              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: TextField(
                  controller: widget.emailController,
                  onChanged: (value) =>
                      Provider.of<AuthViewModel>(context, listen: false)
                          .email = value,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    border: InputBorder.none
                
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight*0.05,),
            Container(
               width: screenWidth*0.8,
              decoration: BoxDecoration(color: const Color.fromARGB(76, 217, 217, 217),borderRadius: BorderRadius.circular(10),),

              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: TextField(
                  controller: widget.passwordController,
                  onChanged: (value) =>
                      Provider.of<AuthViewModel>(context, listen: false)
                          .password = value,
                  decoration: const InputDecoration(
                    hintText: "Password",
                    border: InputBorder.none
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight*0.06,),
            ElevatedButton(onPressed: (){
              Provider.of<AuthViewModel>(context, listen: false)
                        .signUpUser(context);

            }, 
            
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,),
              child:  Text("Register",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,fontSize: screenHeight*0.02),),),


              SizedBox(height: screenHeight*0.03,),

              RichText(text:TextSpan(
                text: "Already have an account? ",
                style: TextStyle(fontSize: screenHeight*0.02,color: Colors.black),
                children: [
                  TextSpan(
                    text: "Sign in",
                    style: TextStyle(fontSize: screenHeight*0.02,color: Colors.white),
                    recognizer: TapGestureRecognizer()..onTap = ()=>
                      Navigator.pushReplacementNamed(context, RouteName.loginScreen)
                    
                  )
                ]
              ))

     

          ],
        ),),),
    
    );
  }
}