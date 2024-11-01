const AccountSetting = require("../models").accountSettings

exports.getAllAccountSettings = async () => {
    return await AccountSetting.find({});
};
  
  // Function to create a new Account
exports.createAccountSetting = async (AccountSettingData) => {
    const newAccountSetting = new AccountSetting(AccountSettingData);
    return await newAccountSetting.save();
};

exports.getAccountSettingByID = async (AccountSettingId) => {
    return await AccountSetting.findById(AccountSettingId);
}

exports.updateAccountSetting = async (AccountSettingId, updateData) => {
    return await AccountSetting.findByIdAndUpdate(AccountSettingId, updateData, { new: true });
}

exports.deleteAccountSetting = async (AccountSettingId) => {
    return await AccountSetting.findByIdAndDelete(AccountSettingId);
}