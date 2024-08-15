const TaskSchema = require("../models/task_model");
const User = require("../models/user_model");
const GeminiService = require("../services/gemini_service");

const geminiModel = require('../services/gemini_service');
const TodoService = require("../services/todo_service");
var taskService =new TodoService();
var geminiService =new GeminiService();

async function getAllTasks(req,res,next){
    try {
        const {status} = req.query;
        const {user} = req.body;
        console.log(user);
        // const userdoc = await User.findOne({_id:user},{"todos.taskName":1,"todos.completed":1,"todos.date":1,"todos.time":1});
        const userdoc  = await taskService.getAllTasks({userId:user});
        let resultArr = userdoc.todos;
        if(status){
            console.log("i came here");
             resultArr = userdoc.todos.filter((elem)=>status=="completed"?elem.completed:!elem.completed);

        }
        res.status(200).json({ status: "success",todos:resultArr,message:"All tasks returned",});
    } catch (error) {
        next(error);    
    }
}
async function createTask(req,res,next){
    const date = new Date();
    try {
        var myTask;
        // console.log(`this is the name of the task ${req.body.taskName} the status of the task is ${req.body.completed} and the id of the user is ${req.body.user}`);
        const myUser = await taskService.createTask({
            userId:req.body.user,taskName:req.body.taskName,date:req.body.date,time:req.body.time
        });
        res.status(200).json({ status: "success",message:"task was created",task: myUser.todos[myUser.todos.length-1]});
    } catch (error) {
        next(error);
    }

}
async function getTaskById(req,res,next){
    console.log(req.params.id)
    try {
        const myTask = await taskService.getTaskById({userId:req.body.user,taskId:req.params.id})
        
        console.log(myTask.todos[0]);
        if(myTask.todos[0]){
            res.status(200).json({ status: "success",task:myTask.todos[0],message:"task was found" });

        }else {
            const myError = new Error("No task was found with the given id");
            myError.status = 401;
            throw myError;
        }

        

    } catch (error) {
        next(error);
    }
    
}
async function updateTask(req,res,next){
    const {user,taskName,time,date,completed} = req.body;


    try {
        await taskService.updateTask({userId:user,taskName:taskName,time:time,date:date,completed:completed});
        res.status(200).json({ status: "success",message:"task was updated" });
        
    } catch (error) {

        next(error);
    }
    
}
async function deleteTask(req,res,next){
    const {user} = req.body;
    const taskId =req.params.id;
    try {
        await taskService.deleteTask({userId:user,taskId})
        res.status(200).json({ status: "success",message:"task was deleted" });
        
    } catch (error) {

        next(error);
    }
}


//my extra work
async function uploadFromPicture(req,res,next){
    console.log("the request is ",req.files);
    const {image} = req.files;
    try {
        const toStore = await geminiService.sendPromptToServer({image:image});
        const createdtodos = await taskService.addFromPic({userId:req.body.user,toStore})
        res.status(200).json({ status: "success",todos:createdtodos,message:"The todos were added",});

    } catch (error) {
        next(error);    
    }
}


module.exports = {
    getAllTasks,
    createTask,
    getTaskById,
    updateTask,
    deleteTask,
    
    uploadFromPicture
}