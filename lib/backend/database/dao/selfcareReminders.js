const reminders = require("../models").selfcareReminders

exports.getAllReminders = async () => {
    return await reminders.find({});
};

exports.getAllUserReminders = async (userId) => {
    return await reminders.find({user_id:userId});
}
  
exports.createReminder = async (remindersData) => {
    const newReminder = new reminders(remindersData);
    return await newReminder.save();
};

exports.getReminderByID = async (reminderId) => {
    return await reminders.findById(reminderId);
}

exports.updateReminder = async (reminderId, updateData) => {
    return await reminders.findByIdAndUpdate(reminderId, updateData, { new: true });
}

exports.getReminderByUserIdAndTitle = async (userId, reminderTitle) => {
    return await reminders.findOne({ user_id: userId, title: reminderTitle });
}

exports.deleteReminder = async (remindersId) => {
    return await reminders.findByIdAndDelete(remindersId);
}