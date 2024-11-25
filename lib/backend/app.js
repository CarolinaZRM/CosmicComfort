const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');

// Import route files
const userRoutes = require('./database/routes/user');
const accountRoutes = require('./database/routes/account');
const accSettingRoutes = require('./database/routes/accSetting');
const fakeCallRoutes = require('./database/routes/fakeCall');
const calendarRoutes = require('./database/routes/calendar');

// Setup enviroment variables
dotenv.config();

// Initialize Express app
const app = express();

// Middleware
app.use(cors()); // Enable cross-origin requests
app.use(express.json()); // Parse incoming JSON requests

// Connect to MongoDB (replace with your MongoDB URI)
mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.error('Error connecting to MongoDB', err));

// Use routes (map them to the endpoints)
app.use('/user', userRoutes);       // All user-related routes prefixed with /api/user
app.use('/account', accountRoutes);
app.use('/account_settings', accSettingRoutes);
app.use('/fake_call', fakeCallRoutes);  
app.use('/calendar', calendarRoutes);  


// Start the server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});