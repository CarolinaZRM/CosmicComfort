const mongoose = require('mongoose');
const {
  userSchema,
//  accountSchema,
  accSettingSchema,
  calendarSchema,
  selfcareSchema,
  fakeCallSchema,
  fakeChatSchema,
  moodLogSchema,
  contentSchema,
} = require('./dbSchemas'); // Assuming the schemas are in dbSchemas.js

// Define schema models
const user = mongoose.model('user', userSchema);
//const account = mongoose.model('account', accountSchema);
const accountSettings = mongoose.model('account_settings', accSettingSchema);
const calendar = mongoose.model('calendar', calendarSchema);
const selfcareReminders = mongoose.model('selfcare_reminders', selfcareSchema);
const fakeCall = mongoose.model('fake_call', fakeCallSchema);
const fakeChat = mongoose.model('fake_chat', fakeChatSchema);
const moodLog = mongoose.model('mood_log', moodLogSchema);
const content = mongoose.model('content', contentSchema);

module.exports = {
    user,
//    account,
    accountSettings,
    calendar,
    selfcareReminders,
    fakeCall,
    fakeChat,
    moodLog,
    content,
};