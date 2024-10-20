//import "dbSchemas.js";
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');

const { 
    userSchema, 
    accountSchema, 
    accSettingSchema, 
    calendarSchema, 
    selfcareSchema, 
    fakeCallSchema, 
    fakeChatSchema, 
    moodLogSchema, 
    contentSchema 
} = require('./dbSchemas');

dotenv.config({ path: '../.env' });

const app = express();
app.use(cors());
app.use(express.json());

// MongoDB connection
mongoose.connect(process.env.MONGO_URI)
    .then(() => console.log('Connected to MongoDB'))
    .catch((err) => console.error('MongoDB connection error:', err));

// Define schema models
const user = mongoose.model('user', userSchema);
const account = mongoose.model('account', accountSchema);
const accountSettings = mongoose.model('account_settings', accSettingSchema);
const calendar = mongoose.model('calendar', calendarSchema);
const selfcareReminders = mongoose.model('selfcare_reminders', selfcareSchema);
const fakeCall = mongoose.model('fake_call', fakeCallSchema);
const fakeChat = mongoose.model('fake_chat', fakeChatSchema);
const moodLog = mongoose.model('mood_log', moodLogSchema);
const content = mongoose.model('content', contentSchema);

const createCollections = async () => {
    try {
        await user.createCollection();
        await account.createCollection();
        await accountSettings.createCollection();
        await calendar.createCollection();
        await selfcareReminders.createCollection();
        await fakeCall.createCollection();
        await fakeChat.createCollection();
        await moodLog.createCollection();
        await content.createCollection();
        console.log('Collections created!');
    } catch (err) {
        console.error('Error creating collections:', err);
    }
};

// Create the collections
createCollections();

// Define server port and start listening
const port = process.env.PORT || 5000;
app.listen(port, () => console.log(`Server running on port ${port}`));