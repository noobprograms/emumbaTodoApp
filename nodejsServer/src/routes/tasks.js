const express = require("express");
const taskRouter = express.Router();
const {taskFunctions}= require('../controllers');
const { verifyMiddleware } = require("../middleware/");


taskRouter.get("/",taskFunctions.getAllTasks);
taskRouter.post("/",taskFunctions.createTask);
taskRouter.get("/:id",taskFunctions.getTaskById);
taskRouter.put("/:id",taskFunctions.updateTask);
taskRouter.delete("/:id",taskFunctions.deleteTask);
// taskRouter.get("/completed",taskFunctions.listCompletedTasks);
// taskRouter.get("/pending",taskFunctions.listPendingTasks);
taskRouter.post("/photo/create",verifyMiddleware.verifyImageUpload,taskFunctions.uploadFromPicture);



module.exports = taskRouter;