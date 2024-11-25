const moodLog = require("../models").moodLog

exports.getAllMoodLogs = async () => {
    return await moodLog.find({});
};
  
  // Function to create a new moodLog
exports.createMoodLog = async (moodLogData) => {
    const newmoodLog = new moodLog(moodLogData);
    return await newmoodLog.save();
};

exports.getMoodLogByID = async (moodLogId) => {
    return await moodLog.findById(moodLogId);
}

exports.updateMoodLog = async (moodLogId, updateData) => {
    return await moodLog.findByIdAndUpdate(moodLogId, updateData, { new: true });
}

exports.deleteMoodLog = async (moodLogId) => {
    return await moodLog.findByIdAndDelete(moodLogId);
}