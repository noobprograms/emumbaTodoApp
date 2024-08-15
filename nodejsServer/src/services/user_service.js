const User = require("../models/user_model");

class UserService{
    async getOneUser({userId}){
        try {
            const myUser = await User.findById(userId);
            return myUser;
        } catch (e) {
            throw e;
        }
    }
    async createUser({username,email,password,todos}){
        try {
            const myUser = await User.create({
                username,
                email,
                password: myHash,
                todos,
            });
            return myUser;
        } catch (e) {
            throw e;            
        }
    }
    async checkUserValidity({user,password}){
        try {
            const result = await user.isValidPassword(password);
            return result;
        } catch (e) {
            throw e;
        }
    }

   

}
module.exports =UserService;