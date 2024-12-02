//import "dbSchemas.js";
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');

const { 
    userSchema, 
//    accountSchema, 
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
const {
    user,
//    account,
    accountSettings,
    calendar,
    selfcareReminders,
    fakeCall,
    fakeChat,
    moodLog,
    content
} = require("./models")

const createCollections = async () => {
    try {
        await user.createCollection();
//        await account.createCollection();
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
// const port = process.env.PORT || 3000;
// for Carolina's laptop:
const port = process.env.PORT || 9000;
app.listen(port, () => console.log(`Server running on port ${port}`));