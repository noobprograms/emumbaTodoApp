const express = require('express');
const app = express();

app.get("/",(req,res)=>{
    res.send("initial route to check whether thisi works or not")
});

app.listen(8712,()=>console.log("the server is running on 8712 port"));