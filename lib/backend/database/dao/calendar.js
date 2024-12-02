const Calendar = require("../models").calendar

exports.getAllCalendars = async () => {
    return await Calendar.find({});
};
  
  // Function to create a new calendar
exports.createCalendar = async (CalenarData) => {
    const newCalendar = new Calendar(CalenarData);
    return await newCalendar.save();
};

exports.getCalendarByID = async (calendarId) => {
    return await Calendar.findById(calendarId);
}

exports.updateCalendar = async (calendarId, updateData) => {
    return await Calendar.findByIdAndUpdate(calendarId, updateData, { new: true });
}

exports.deleteCalendar = async (calendarId) => {
    return await Calendar.findByIdAndDelete(calendarId);
}

exports.getCalendarByUserId = async (userId) => {
    return await Calendar.findOne({ user_id: userId });
}

exports.addOrUpdateMoodLog = async (userId, date, color, mood, description) => {
    await Calendar.updateOne(
        { user_id: userId, "dateColors.date": date },
        {
            $set: {
                "dateColors.$.color": color,
                "dateColors.$.mood": mood,
                "dateColors.$.description": description,
            },
        },
        { upsert: true }
    );
};