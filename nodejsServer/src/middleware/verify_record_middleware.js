const express = require('express');
const User = require('../models/user_model')
const jwt = require('jsonwebtoken');
const { client } = require('../services/init_redis');

async function verifyRecordForSignup(req, res, next) {
    let { username, email, password } = req.body;


    try {

        if (!username || !email || !password) {
            const myError = new Error("One of the fields was not provided")
            myError.status = 400;
            throw myError;
        }
        username = username.trim();
        password = password.trim();
        email = email.trim();
        //checking if the user already exists with this email
        let toFind = await User.findOne({ email: email });


        if (toFind) {
            const myError = new Error("Email is already registered");
            myError.status = 409;
            throw myError;
        }
        //checking to see if the user exists with the username
        toFind = await User.findOne({ username: username });


        if (toFind) {
            const myError = new Error("Username is already registered");
            myError.status = 409;
            throw myError;
        }
        console.log("i am coming inside this if statement");

        next()
    } catch (error) {

        next(error)
    }
}
async function verifyRecordForSignIn(req, res, next) {

    let { email, password } = req.body;
    try {
        if (!email || !password) {

            const myError = new Error("One of the fields was not provided")
            myError.status = 400;
            throw myError;
        }
        password = password.trim();
        email = email.trim();
        const user = await User.findOne({ email: email });
        if (!user) {
            const myError = new Error("User not found");
            myError.status = 401;
            throw myError;
        }
        req.body.user = user;
        
        next();

    } catch (e) {
        next(e);
    }
}

async function verifyAccess(req, res, next) {

    try {
        const authHeader = req.headers.authorization;
        if (!authHeader) {
            const myError = new Error("No token provided");
            myError.status = 401;
            throw myError;
        }
        const token = authHeader.split(" ")[1];
        const result = await client.lRange('token',0,99999999)
        if(result.indexOf(token) > -1){
            const myError  = new Error("You are logged out. Login to continue");
            myError.status = 400;
            throw myError;
        }
        const isVerified = await new Promise((resolve, reject) => {
            jwt.verify(token, process.env.ACCESS_JWT_SECRET, function(error, decoded) {
                if (error) {
                    if (error.name === 'JsonWebTokenError') {
                        const myError = Error("You are not authorized to access this.");
                        myError.status = 401;
                        reject(next(myError));
                    } else {
                        const myError = Error(error.message);
                        myError.status = 401;
                        reject(next(myError));
                    }


                }

                resolve(decoded);
            })
        });
        if (!isVerified) {
            const myError = new Error("Invalid token");
            myError.status = 401;
            throw myError;

        }
        req.body.user = isVerified.aud;
        next();
    } catch (error) {
        next(error);
    }

}
async function verifyImageUpload(req,res,next){
    console.log("the requst files is ");
    const { image } = req.files;
    if(!image){
        const myError = new Error("No image was provided");
        myError.status = 401;
        throw myError;
    }
    if(!/^image/.test(image.mimetype)){
        const myError = new Error("The file provided is not an image");
        myError.status = 401;
        throw myError;
    }
    next();
}
async function verifyRefreshToken(req, res, next) {
    try {
        const refreshToken = req.body.refreshToken;
        const authHeader = req.headers.authorization;
        if (!authHeader) {
            const myError = new Error("No token provided");
            myError.status = 401;
            throw myError;
        }
        const token = authHeader.split(" ")[1];
        if (!refreshToken) {


            const myError = new Error("No refresh Token provided");
            myError.status = 401;
            throw myError;
        }
        

        const result = await client.lRange('token',0,99999999)
        if(result.indexOf(token) > -1){
            const myError  = new Error("You are logged out. Login to continue");
            myError.status = 400;
            throw myError;
        }
        const userID = await new Promise((resolve, reject) => {
            jwt.verify(refreshToken, process.env.REFRESH_JWT_SECRET, function(error, decoded) {
                if (error) {
                    reject(next(error))
                }
                resolve(decoded.aud);
            })
        });
        req.body.userID = userID;
        client.get(userID, (err, result) => {
            if (err) { next(err) }
            if (refreshToken != result) {

                const myError = new Error("Invalid refresh token");
                myError.status = 401;
                throw myError;
            }
        });
        next();


    } catch (error) {
        next(error);
    }

}

module.exports = { verifyRecordForSignup, verifyRecordForSignIn, verifyAccess, verifyRefreshToken,verifyImageUpload };