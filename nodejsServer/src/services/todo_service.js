const User = require("../models/user_model");

class TodoService{
    async getAllTasks({userId}){
        try{
        const userdoc = await User.findOne({_id:userId},{"todos.taskName":1,"todos.completed":1,"todos.date":1,"todos.time":1,'todos._id':1});
        return userdoc;
        }catch(e){
            throw e
            
        }
    }
    async createTask({userId,taskName,status=false,time="",date=""}){
        try{
            const myUser = await User.findByIdAndUpdate(userId,{$addToSet:{'todos':[{taskName:taskName,completed:status,time:time,date:date}]}},{returnOriginal:false});
            return myUser;
        }catch(e){
            throw e;
        }
    }
    async getTaskById({userId,taskId}){
        try {
            // const myTask = await User.findOne({_id:userId}).select({todos:{$elemMatch:{_id:taskId}},"todos.taskName":1,"todos.completed":1});
        const myTask = await User.findOne({_id:userId,"todos._id":taskId},{'todos.taskName':1,'todos.completed':1,'todos.date':1,'todos.time':1,'todos._id':1})

            return myTask;
        } catch (e) {
            throw e;
        }
    }   
    async updateTask({userId,taskId,taskName,time,date,completed}){
        try {
            const specificTodo = await User.findOne({_id:userId}).select({todos:{$elemMatch:{_id:taskid}}}).catch((error)=>{
                if(error.message.includes("Found empty object at path")){
                    const myError = new Error("No todo found with the provided id");
                    myError.status = 401;
                    throw myError;
                }
            })
            console.log(specificTodo.todos[0]);
            const todoMap = specificTodo.todos[0];
            
            await User.findOneAndUpdate({_id:userId,"todos._id":taskId},{"$set":{
                "todos.$.taskName":taskName??todoMap.taskName,
                "todos.$.time":time??todoMap.time,
                "todos.$.date":date??todoMap.date,
                "todos.$.completed":completed??todoMap.completed,
                
            }});
        } catch (e) {
            throw e
        }
    }
    async addFromPic({userId,toStore}){
        try {
        const myUser = await User.findByIdAndUpdate(userId,{$addToSet:toStore},{returnOriginal:false});
        return myUser["todos"].slice(-toStore.todos.length);
            
        } catch (e) {
            throw e;
        }
    }
    async deleteTask({userId,taskId}){
        try {
            await User.updateOne(
                {"_id": userId},
                {
                  "$pull": {
                    "todos":{
                      "_id": taskId
                    }
                    }
                    }
                ).catch((error)=>{
                    const myError = new Error("The todo with the provided id does not exist. Cannot delete");
    
                    myError.status = 401;
                    throw myError;
                })
        } catch (e) {
            throw e;
        }
    }
}
module.exports = TodoService;