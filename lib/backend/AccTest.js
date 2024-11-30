const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');
const admin = require('firebase-admin');
const bcrypt = require('bcrypt');
const bodyParser = require('body-parser');

// Initialize environment variables
dotenv.config();

// Initialize Express
const app = express();
app.use(cors());
app.use(express.json());
app.use(bodyParser.json());

// Initialize Firebase Admin
const serviceAccount = require('./config/CosmicComfortServiceAccountKey.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// MongoDB connection
mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.error('MongoDB connection error:', err));

// Schemas
const userSchema = new mongoose.Schema({
  first_name: { type: String, required: true },
  last_name: { type: String, required: true },
});

const accountSchema = new mongoose.Schema({
  user_id: { type: String, required: true },
  display_name: { type: String, required: true },
  email: { type: String, required: true },
  password: { type: String, required: true },
  date_created: { type: Date, default: Date.now },
});

// Models
const User = mongoose.model('User', userSchema);
const Account = mongoose.model('Account', accountSchema);

// Routes
// Create Account
app.post('/account', async (req, res) => {
  try {
    const { user_id, display_name, email, password } = req.body;

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Save account data
    const newAccount = new Account({
      user_id,
      display_name,
      email,
      password: hashedPassword,
    });

    await newAccount.save();
    res.status(201).json({ message: 'Account created successfully', account: newAccount });
  } catch (err) {
    res.status(500).json({ message: 'Server Error', error: err });
  }
});

// Get Account by ID
app.get('/account/:id', async (req, res) => {
  try {
    const account = await Account.findById(req.params.id);
    if (!account) return res.status(404).json({ message: 'Account not found' });
    res.json(account);
  } catch (err) {
    res.status(500).json({ message: 'Server Error', error: err });
  }
});

// Root Route
app.get('/', (req, res) => {
  res.send('Welcome to the backend API');
});

// Start Server
const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Server running on port ${port}`));
