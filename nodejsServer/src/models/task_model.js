const mongoose = require("mongoose")
const date = new Date();
const crntTime = date.getHours()+':'+date.getMinutes()+":"+date.getSeconds();
const crntDate = date.getDate()+'-'+(date.getMonth()+1)+'-'+date.getFullYear();
const TaskSchema = new mongoose.Schema({
    taskName: {type:String},
    currentTime: {
        type: String,
        default:crntTime,
    },
    currentDate: {
        type: String,
        default:crntDate,
    },
    time:{
        type: String,
        required:false,
    },
    date:{
        type:String,
        required:false,
    },
    completed: { type: Boolean, required: true,default:false },
});


 

module.exports = TaskSchema;