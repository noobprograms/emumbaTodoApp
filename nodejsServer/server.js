const express = require('express');
const mongoose = require("mongoose");
const app = express();
const router = require("./src/routes");
const {errorMiddleware,loggerMiddleware} = require("./src/middleware");
const {errorHandler} = require("./src/controllers")
const { clientInit } = require('./src/services/init_redis');
const fileUpload = require('express-fileupload')
clientInit();
mongoose.connect(process.env.MONGODB_URL, { dbName: "todo_database" }).then(() => {

    console.log("connected to mongodb");
});

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(fileUpload());
app.use(loggerMiddleware);


app.use("/",router);
app.use(errorHandler);
app.use(errorMiddleware);
app.listen(8712,()=>console.log("the server is running on 8712 port"));