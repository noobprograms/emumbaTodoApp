const express = require('express');
const {verifyMiddleware} = require('../middleware')
const userRouter = express.Router();
const {userFunctions} = require("../controllers");
userRouter.get("/:id",verifyMiddleware.verifyAccess,userFunctions.getOneUser);
userRouter.post("/registerUser",verifyMiddleware.verifyRecordForSignup,userFunctions.registerUser);
userRouter.post("/signInUser",verifyMiddleware.verifyRecordForSignIn,userFunctions.signInUser);
userRouter.delete("/logoutUser",verifyMiddleware.verifyRefreshToken,userFunctions.logout);


module.exports = userRouter;