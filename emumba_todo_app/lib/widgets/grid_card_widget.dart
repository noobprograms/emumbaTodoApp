import 'package:emumba_todo_app/models/task.dart';
import 'package:emumba_todo_app/utils/constants/imageConstants.dart';
import 'package:emumba_todo_app/utils/routes/routeNames.dart';
import 'package:emumba_todo_app/view_models/auth_view_model.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class GridCardWidget extends StatelessWidget {
   GridCardWidget({required this.type, this.number,super.key});
    
  final String type;
   int? number;
   TextEditingController taskNameController = TextEditingController();
   TextEditingController taskDate = TextEditingController();
   TextEditingController time = TextEditingController();
   TextEditingController date = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
     double screenHeight = MediaQuery.of(context).size.height;
    

    return Card(  color:type=="Add Task"? Theme.of(context).focusColor:type=="Completed"?Colors.green:Colors.yellow,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [type!="Add Task"?CircleAvatar(
                            child: Image.asset(type=="Completed"?ImageConstants.checkmark:ImageConstants.pending),
                          ):Row(children: [GestureDetector(
                            onTap: (){
                              showModalBottomSheet(context: context, builder: ((context) => StatefulBuilder(
                              
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
                                                    controller: taskNameController,
                                                    onChanged: (value) =>
                                                        Provider.of<AuthViewModel>(context, listen: false)
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
                                                    children: [Text("${Provider.of<AuthViewModel>(context,listen: false).selectedTime!.hour}:${Provider.of<AuthViewModel>(context,listen: false).selectedTime!.minute}"), 
                                                                SizedBox(width: 10,),
                                                                ElevatedButton(onPressed: ()async{
                                                                  Provider.of<AuthViewModel>(context,listen: false).selectedTime = await showTimePicker(
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
                                                    children: [Text("${Provider.of<AuthViewModel>(context,listen: false).selectedDate!.day}:${Provider.of<AuthViewModel>(context,listen: false).selectedDate!.month}:${Provider.of<AuthViewModel>(context,listen: false).selectedDate!.year}"), 
                                                                SizedBox(width: 10,),
                                                                ElevatedButton(onPressed: ()async{
                                                                  Provider.of<AuthViewModel>(context,listen: false).selectedDate = await showDatePicker(
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
                                              ElevatedButton(onPressed: ()async{
                                                await Provider.of<AuthViewModel>(context, listen: false)
                                                          .addTask(context);


                                              }, 
                                              
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Theme.of(context).primaryColor,
                                                  foregroundColor: Colors.white,),
                                                child:  Text("Create Task",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,fontSize: screenHeight*0.02),),),
                                  ],
                                  );
                                }
                              )));
                            },
                            child: CircleAvatar(
                              child: Image.asset(ImageConstants.addTask),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context, RouteName.imageSelectionScreen);
                            },
                            child: CircleAvatar(
                              child: Image.asset(ImageConstants.cameraImage),
                            ),
                          )
                          
                          
                          ],),
                          SizedBox(height: screenHeight*0.015,),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text(type,style: TextStyle(color: Colors.white),),type!="Add Task"?Text('${number}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),):Container()],)
                          ],
                        ),
                      ),);
  }
}