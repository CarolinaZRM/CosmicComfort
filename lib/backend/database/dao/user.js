const User = require("../models").user

exports.getAllUsers = async () => {
    return await User.find({});
};
  
  // Function to create a new user
exports.createUser = async (userData) => {
    const newUser = new User(userData);
    return await newUser.save();
};

exports.getUserByID = async (userId) => {
    return await User.findById(userId);
}

exports.updateUser = async (userId, updateData) => {
    return await User.findByIdAndUpdate(userId, updateData, { new: true });
}

exports.deleteUser = async (userId) => {
    return await User.findByIdAndDelete(userId);
}

// check if username and password exists in db
// TODO: once the login works, refactor to incluce password hashing
exports.loginUser = async (username, password) => {
    try{
        //return await User.findOne(username, password);
        const user = await User.findOne({username: username, password: password });
        // console.log("user credentials in DAO:", user);

        return user;

    } catch (e){
        console.error("Error in loginUser DAO:", e);
        throw(e);
    }
}
