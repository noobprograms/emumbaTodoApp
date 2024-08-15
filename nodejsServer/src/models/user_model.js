const mongoose = require("mongoose")
const bcrypt = require("bcryptjs")
const TodoSchema =  require("./task_model");
const UserSchema = new mongoose.Schema({
    username: { type: String, unique: true },
    email: {
        type: String,
        unique: true,
        required: true,
        lowercase: true,
        match: [/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*$/, "Please enter a valid email"],

    },
    password: { type: String, required: true, },
    todos:[TodoSchema],
});
UserSchema.methods.isValidPassword = async function(password) {
    try {
        return await bcrypt.compare(password, this.password);
    } catch (error) {
        throw error;
    }

}
const User = mongoose.model('user', UserSchema);


module.exports = User;