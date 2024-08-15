const taskRouter = require("./tasks")
const userRouter = require("./users")

const { verifyMiddleware } = require("../middleware/");

const  express =  require('express');

const router = express.Router();
router.use('/users', userRouter);
router.use('/tasks',verifyMiddleware.verifyAccess,taskRouter)
module.exports = 
    router;
