const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');

//DB Schemas imported
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
} = require('./database/dbSchemas');

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

// MongoDB connection
mongoose.connect(process.env.MONGO_URI)
    .then(() => console.log('Connected to MongoDB'))
    .catch((err) => console.error('MongoDB connection error:', err));




const User = mongoose.model('User', userSchema);

// Routes
// Create user
app.post('/user', async (req, res) => {
    try {
        const requiredFields = ['first_name', 'last_name'];

        // Check for additional fields in the request body
        const extraFields = Object.keys(req.body).filter(field => !requiredFields.includes(field));

        if (extraFields.length > 0) {
            return res.status(400).json({ 
                message: 'Validation Error: Extra fields detected.', 
                extraFields 
            });
        }

        const newUser = new User(req.body);
        await newUser.save();
        res.status(201).json(newUser);
    } catch (err) {
        if (err.name === 'ValidationError') {
            const errors = Object.keys(err.errors).map(field => ({
                field,
                message: err.errors[field].message
            }));
            return res.status(400).json({ message: 'Validation Error', errors });
        }
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

// Get all users
app.get('/user', async (req, res) => {
    try {
        const users = await User.find();
        if (!users || users.length === 0) return res.status(404).json({ message: 'No users in collection' });
        res.json(users);
    } catch (err) {
        res.status(500).json({ message: 'Server Error' });
    }
});

const port = process.env.PORT || 5000;
app.listen(port, () => console.log(`Test Server running on port ${port}`));