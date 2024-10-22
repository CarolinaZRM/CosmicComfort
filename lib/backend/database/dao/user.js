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