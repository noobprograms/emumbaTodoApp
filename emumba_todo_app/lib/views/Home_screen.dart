import 'package:emumba_todo_app/models/task.dart';
import 'package:emumba_todo_app/utils/constants/imageConstants.dart';
import 'package:emumba_todo_app/utils/routes/routeNames.dart';
import 'package:emumba_todo_app/view_models/auth_view_model.dart';
import 'package:emumba_todo_app/view_models/task_view_model.dart';
import 'package:emumba_todo_app/widgets/grid_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController taskNameController = TextEditingController();
    double screenWidth = MediaQuery.of(context).size.width;
     double screenHeight = MediaQuery.of(context).size.height;

     return PopScope(
      canPop: false,
       child: Scaffold(
        
        
        body: SingleChildScrollView(
          child: Container(
            width: screenWidth,
            height: screenHeight,
          
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromRGBO(65, 107, 163, 1),Color.fromRGBO(73, 134, 188, 1),Color.fromRGBO(98, 144, 200, 1),Color.fromRGBO(130, 156, 188, 1)],
                begin: Alignment.bottomLeft,
                end:Alignment.topRight)), 
            child: Padding(
              padding:  EdgeInsets.fromLTRB(screenWidth*0.08,screenHeight*0.08,screenWidth*0.08,8),
              child: Consumer<AuthViewModel>(
                      builder: (context,authprovider,child) {
                         
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Hello ${Provider.of<AuthViewModel>(context,listen: false).myUser.username}",style: TextStyle(fontSize: screenHeight*0.023,fontWeight: FontWeight.w500,color: Colors.white),),
                              Text('You have work today!',style: TextStyle(fontSize: screenHeight*0.015,color: Colors.white),)
                            ],
                          ),
                          InkWell(
                            onTap: (){
                              Provider.of<AuthViewModel>(context, listen: false).signOutUser(context);
                            },
                            child: Container(
                                  width:screenWidth*0.22,
                                  height: screenHeight*0.05,
                                  child: Text('Sign Out',style: TextStyle(color: Colors.red),),
                                ),
                          ),
                        ],
                      ),
                      GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: (screenWidth/ screenHeight/0.3),
                        children: [GestureDetector(onTap:(){
                          Navigator.pushNamed(context, RouteName.completedScreen);
                        },child: GridCardWidget(type:"Completed",number: authprovider.completed.length,)),GestureDetector(onTap: (){
                          Navigator.pushNamed(context, RouteName.pendingScreen);
                        },child: GridCardWidget(type:"Pending",number: authprovider.pending.length,)),GridCardWidget(type:"Add Task")
                        ],
                      ),
                      SizedBox(height: screenHeight*0.02),
                      const Text("All Tasks",style: TextStyle(color: Colors.white),),
                      // ElevatedButton(onPressed: (){
                        
                  
                      // }, child: Text('press me to load tasks')),
                      Expanded(
                        child: ListView.separated(
                                shrinkWrap: true,
                                   itemCount: authprovider.allTasks.length,
                                   separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
                                   itemBuilder: (BuildContext context, int index) {
                                    Task myTask = authprovider.allTasks[index];
                                    
                                     return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        // border: Border.all(color: Color.fromARGB(255, 5, 41, 69)),
                                        gradient: LinearGradient(
                                                    colors: [Color.fromRGBO(65, 107, 163, 1),Color.fromRGBO(73, 134, 188, 1),Color.fromRGBO(98, 144, 200, 1),],
                                                    begin: Alignment.bottomLeft,
                                                    end:Alignment.topRight),),
                                      child: ListTile(
                                                  
                                                  titleAlignment:ListTileTitleAlignment.center,
                                                  title: Text(myTask.taskName,style: TextStyle(fontSize: screenHeight*0.02,fontWeight: FontWeight.bold,color: Colors.white),),
                                                  subtitle: Text(myTask.time,style: TextStyle(color: Colors.white),),
                                                  leading: Checkbox(

                                                    value: myTask.completed,
                                                    
                                                    onChanged: (value){

                                                      authprovider.markAsComplete(context, myTask);
                                                    },
                                                  ),
                                                  trailing: SizedBox(width: screenWidth*0.25,child: Row(children: [IconButton(onPressed: (){

                                                    showModalBottomSheet(context: context, builder: ((context)  {
                                                    
                                                      return StatefulBuilder(
                              
                                builder: (context, StateSetter setState) {
                                  
                                  return Column(
                                    children: [
                                      SizedBox(width: screenWidth,),
                                      SizedBox(height:screenHeight*0.01),
                                      Container(
                                                width: screenWidth*0.8,
                                                decoration: BoxDecoration(color: const Color.fromARGB(76, 217, 217, 217),borderRadius: BorderRadius.circular(10),),
                                  
                                                child: Padding(
                                                  padding: const EdgeInsets.all(6.0),
                                                  child: TextField(
                                                    controller: taskNameController..text=myTask.taskName,
                                                    onChanged: (value) =>
                                                        authprovider
                                                            .taskName = value,
                                                    decoration: const InputDecoration(
                                                      hintText: "Task Name",
                                                      border: InputBorder.none
                                                  
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: screenHeight*0.01,),
                                              Container(
                                                width: screenWidth*0.8,
                                                
                                                decoration: BoxDecoration(color: const Color.fromARGB(76, 217, 217, 217),borderRadius: BorderRadius.circular(10),),
                                  
                                                child: Padding(
                                                  padding: const EdgeInsets.all(6.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [authprovider.timeWasUpdated?Text("${authprovider.selectedDate}"):Text("${myTask.time}"), 
                                                                SizedBox(width: 10,),
                                                                ElevatedButton(onPressed: ()async{
                                                                  authprovider.timeWasUpdated = true;
                                                                  authprovider.selectedTime = await showTimePicker(
                                                                          initialTime: TimeOfDay.now(),
                                                                          context: context,
                                                                        );
                                                                  setState((){
                                                                  });
                                                                },                                                                  
                                                                  child: Icon(Icons.schedule),
                                                                        )
                                                              ],
                                                  )
                                                ),
                                              ),
                                              SizedBox(height: screenHeight*0.01,),
                                              Container(
                                                width: screenWidth*0.8,
                                                
                                                decoration: BoxDecoration(color: const Color.fromARGB(76, 217, 217, 217),borderRadius: BorderRadius.circular(10),),
                                  
                                                child: Padding(
                                                  padding: const EdgeInsets.all(6.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [authprovider.dateWasUpdated?Text("${authprovider.selectedDate}"):Text("${myTask.date}"), 
                                                                SizedBox(width: 10,),
                                                                ElevatedButton(onPressed: ()async{
                                                                  authprovider.dateWasUpdated = true;

                                                                 authprovider.selectedDate = await showDatePicker(
                                                                          initialDate: DateTime.now(),
                                                                          firstDate: DateTime.now(),
                                                                          lastDate: DateTime(2050),
                                                                          context: context,
                                                                        );
                                                                        
                                                                        setState((){});
                                                                        
                                                                        },
                                                                  child: Icon(Icons.calendar_month),
                                                                        )
                                                              ],
                                                  )
                                                ),
                                              ),
                                              SizedBox(height: screenHeight*0.01,),
                                              ElevatedButton(onPressed: (){
                                                authprovider.updateTask(context,myTask);
                                              }, 
                                              
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Theme.of(context).primaryColor,
                                                  foregroundColor: Colors.white,),
                                                child:  Text("Update Task",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,fontSize: screenHeight*0.02),),),
                                  ],
                                  );
                                }
                              );}));




                                                  }, icon: Icon(Icons.edit,color: Colors.white,)),IconButton(onPressed: (){
                                                    authprovider.deleteTask(context, myTask.id);
                                                  }, icon: Icon(Icons.delete,color: Colors.white,)),],)),
                                              ),
                                     );
                                   },
                              ),
                         
                        ),
                      
                  
                    ],
                  );
                }
              ),
            ),
          ),
        ),
       ),
     );
  }
}