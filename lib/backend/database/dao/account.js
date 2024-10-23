const Account = require("../models").account

exports.getAllAccounts = async () => {
    return await Account.find({});
};
  
  // Function to create a new Account
exports.createAccount = async (AccountData) => {
    const newAccount = new Account(AccountData);
    return await newAccount.save();
};

exports.getAccountByID = async (AccountId) => {
    return await Account.findById(AccountId);
}

exports.updateAccount = async (AccountId, updateData) => {
    return await Account.findByIdAndUpdate(AccountId, updateData, { new: true });
}

exports.deleteAccount = async (AccountId) => {
    return await Account.findByIdAndDelete(AccountId);
}