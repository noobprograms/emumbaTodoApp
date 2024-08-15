const jwt = require('jsonwebtoken');
const { client } = require('../services/init_redis');

function generateToken(mongo_id) {
    const myToken = jwt.sign({}, process.env.ACCESS_JWT_SECRET, { expiresIn: '1800s', audience: mongo_id.toString() }, );



    return myToken;
}

function generateRefreshToken(mongo_id) {

    const myId = mongo_id.toString();
    const myToken = jwt.sign({}, process.env.REFRESH_JWT_SECRET, { expiresIn: '1y', audience: myId, }, );
    client.set(myId, myToken, 'EX', 365 * 24 * 60 * 60);
    console.log("i got to the point where the clients refresh token was stored inside redis")
    return myToken;
}






module.exports = { generateToken, generateRefreshToken };