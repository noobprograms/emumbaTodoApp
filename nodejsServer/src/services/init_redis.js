const redis = require('redis');
require('dotenv').config()


const client = redis.createClient({
    port: process.env.REDIS_PORT,
    host: process.env.REDIS_HOST,
    username: process.env.REDIS_USERNAME,
    password: process.env.REDIS_PASSWORD,
});

client.on('connect', () => console.log("client is connected to redis"));
client.on('ready', () => console.log("client ready to use"));

client.on('error', (error) => console.log(error.message));

client.on('end', () => console.log("client disconnected from redis"));
//we want to stop it when we press the ctrl+c. This is called sigint event

client.on("SIGINT", () => client.quit());
async function clientInit() {
    await client.connect();
}

module.exports = { client, clientInit };