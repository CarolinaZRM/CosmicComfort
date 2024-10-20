const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');
//NOTE: this file will likely be edited heavily, for proper testing a connection, 
//use test.js instead, will serve as a better CRUD template for the moment

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
} = require('database/dbSchemas');

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

// MongoDB connection
mongoose.connect(process.env.MONGO_URI)
    .then(() => console.log('Connected to MongoDB'))
    .catch((err) => console.error('MongoDB connection error:', err));

// Define a User schema


const User = mongoose.model('User', userSchema);

// Routes
// Create user
app.post('/user', async (req, res) => {
    try {
        const newUser = new User(req.body);
        await newUser.save();
        res.status(201).json(newUser);
    } catch (err) {
        res.status(500).json({ message: 'Server Error' });
    }
});
// Testing get
app.get('/', (req, res) => {
    res.send('Welcome to the backend API');
 });

// Get user by ID
app.get('/user/:id', async (req, res) => {
    try {
        const user = await User.findById(req.params.id);
        if (!user) return res.status(404).json({ message: 'User not found' });
        res.json(user);
    } catch (err) {
        res.status(500).json({ message: 'Server Error' });
    }
});

const port = process.env.PORT || 5000;
app.listen(port, () => console.log(`Server running on port ${port}`));