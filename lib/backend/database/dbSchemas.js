const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    // first_name: { type: String, required: true },
    // last_name: { type: String, required: true },
    username: { type: String, required: true },
    email: { type: String, required: true },
    password: { type: String, required: true },
    date_created: { type: Date, required: true }
});

const accountSchema = new mongoose.Schema({
    user_id: { type: String, required: true },
    display_name: { type: String, required: true },
    email: { type: String, required: true },
    password: { type: String, required: true },
    date_created: { type: Date, required: true }
});

const accSettingSchema = new mongoose.Schema({
    //acc_id: { type: String, required: true },
    user_id: { type: String, required: true },
    theme: { type: String, required: true },
    font_size: { type: Number, required: true },
    self_care: { type: Boolean, required: true },
    log_reminder: { type: Boolean, required: true }
});

const calendarSchema = new mongoose.Schema({
    user_id: { type: String, required: true },
    dateColors: [
        {
            date: { type: Date, required: true }, // Store dates as ISO 8601
            color: { type: String, required: true } // Store colors as hex strings
        }
    ]
});

const selfcareSchema = new mongoose.Schema({
    user_id: { type: String, required: true },
    reminder_type: { type: String, required: true },
    reminder_time: { type: Date, required: true },
    reminder_text: { type: String, required: true },
    frequency: { type: String, required: true },
});

const fakeCallSchema = new mongoose.Schema({
    user_id: { type: String, required: true },
    caller_name: { type: String, required: true },
    call_time: { type: Number, required: true },
    ringtone: { type: Boolean, required: true},
    ring_name: { type: String, required: true}
});

const fakeChatSchema = new mongoose.Schema({
    user_id: { type: String, required: true },
    contact_name: { type: String, required: true },
    chat_content: { type: String, required: true },
    chat_time: { type: Date, required: true }
});

const moodLogSchema = new mongoose.Schema({
    user_id: { type: String, required: true },
    mood: { type: String, required: true },
    date: { type: Date, required: true },
    description: { type: String, required: true}
});

const contentSchema = new mongoose.Schema({
    content_type: { type: String, required: true },
    title: { type: String, required: true },
    description: { type: String, required: true },
    media_url: { type: String, required: true },
    time_created: { type: Date, required: true },
});

module.exports = {
    userSchema,
//    accountSchema,
    accSettingSchema,
    calendarSchema,
    selfcareSchema,
    fakeCallSchema,
    fakeChatSchema,
    moodLogSchema,
    contentSchema,
};