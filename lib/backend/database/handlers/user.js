const { default: mongoose } = require("mongoose");
const userDao = require("../dao/user");  // Import the User DAO
const jwt = require('jsonwebtoken'); // to manage user sessions for authentication
const User = require("../models").user;
const bcrypt = require('bcrypt');

// Handler to get all users :)
exports.getAllUsers = async (req, res) => {
    try {
        const users = await userDao.getAllUsers();
        if (!users || users.length === 0) return res.status(404).json({ message: 'No users in collection' });
        res.json(users);
    } catch (err) {
        res.status(500).json({ message: 'Server Error' });
    }
};

// Handler to create a new user :)
exports.createUser = async (req, res) => {
    const userData = req.body;
    try {
        //const requiredFields = ['first_name', 'last_name'];
        const requiredFields = ['username', 'email', 'password']
        // Check for additional fields in the request body
        const extraFields = Object.keys(userData).filter(field => !requiredFields.includes(field));

        if (extraFields.length > 0) {
            return res.status(400).json({ 
                message: 'Validation Error: Extra fields detected.', 
                extraFields 
            });
        }
        const now = new Date();
        const systemTimeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
        userData.date_created = now.toLocaleString('en-US', { timeZone: systemTimeZone });
        
        // Test for time zone, will be stored in UTC, PR uses UTC-4
        // console.log(`System time zone: ${systemTimeZone}`);
        // console.log(`Current local time: ${userData.date_created}`);

        // hash password before saving
        const saltRounds = 10; // Salts create unique passwords, # of hashing rounds done. 
        userData.password = await bcrypt.hash(userData.password, saltRounds);

        const newUser = await userDao.createUser(userData);
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
};

// Handler to get a user by ID :)
exports.getUserByID = async (req, res) => {
    const userId = req.params.id
    try {
        const user = await userDao.getUserByID(userId);
        if (!user) return res.status(404).json({ message: 'User not found' });
        res.status(200).json(user);
    } catch (err) {
        res.status(500).json({ message: 'Server Error' });
    }
};

// Handler to update a user by ID
exports.updateUser = async (req, res) => {
    const userId = req.params.id;  // Get the user ID from the URL
    const updateData = req.body;   // Get the data to update from the request body
    try {
        //const requiredFields = ['first_name', 'last_name'];
        const requiredFields = ['username', 'email', 'password']
        // Check for additional fields in the request body
        const extraFields = Object.keys(updateData).filter(field => !requiredFields.includes(field));

        if (extraFields.length > 0) {
            return res.status(400).json({ 
                message: 'Validation Error: Extra fields detected.', 
                extraFields 
            });
        }

        const updatedUser = await userDao.updateUser(userId, updateData);  // Update the user via the DAO
        if (!updatedUser) {
            return res.status(404).json({ message: 'User not found' });
        }
        res.status(200).json({ message: 'User updated successfully', user: updatedUser });
    } catch (err) {
        res.status(500).json({ message: 'Error updating user', err: err.message });
    }
};

exports.deleteUser = async (req,res) => {
    const userId = req.params.id;
    try {
        const user = await userDao.deleteUser(userId);
        if (!user) return res.status(404).json({ message: 'User not found' });
        res.status(200).json(user);
    } catch(err) {
        res.status(500).json({ message: 'Error deleting user', err: err.message });
    }
}; 


exports.loginUser = async (req,res) => {
    try {
        console.log("loginUser in Handler has been invoked!");
        const {username, password} = req.body;

        if (!username || !password){
            return res.status(400).json({ message: 'Username and password are required.' });
        }

        // fetch user from DB
        const user = await User.findOne({ username: username }).exec(); 
        console.log("user fetched from DAO:", user);

        if (!user){
            return res.status(404).json({message: "Invalid username or password."})
        }

        // compare input password with hashed password in DB
        const match = await bcrypt.compare(password, user.password);
        // for testing -----------
        // console.log("compare password (", password, "), with user.password (", user.password, ").")
        // ------------------
        console.log("Password match:", match);
        if (!match){
            return res.status(401).json({message: "Invalid username or password."})
        }

        // Generate JWT token
        const token = jwt.sign(
            {id: user._id, username: user.username},
            process.env.JWT_SECRET, // replace JWT_SECRET with actual secret from .env file
            {expiresIn: '1h'} // Token is only valid for an hour
        )

        return res.json({
            message: "Login Successful",
            user,
            token
        });
    } catch (err) {
        console.error("Error in loginUser handler:", err)
        res.status(500).json({message: "Server Error,", error: err.message});
    }

}

// Middleware to validate4 JWT
exports.authenticateToken = async (req,res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1]; // Extract token 

    if (!token) return res.status(401).json({message: "Access Denied. No Token Provided."});

    try{
        // verify token
        const verified = jwt.verify(token, process.env.JWT_SECRET);
        req.user = verified;
        next();
    } catch(e){
        res.status(403).json({message: "Invalid or Expired Token."});
    }
}

exports.updateUsername = async (req, res) => {
    try {
      const userId = req.params.userId;            // Get user ID from request parameters
      const newUsername = req.body.username;       // Get the new username from the request body

      // Ensure new username is provided
      if (!newUsername) {
        return res.status(400).json({ error: 'Username is required' });
      }
      // convert string to objectID
      // Deprecation does not apply to strings, just numbers, so no need to worry!
      const objectIdConversion = new mongoose.Types.ObjectId(userId);
  
      // Update the user's username in the database
      const result = await User.updateOne(
        { _id: objectIdConversion },
        { $set: { username: newUsername } } // in MongoDB, $set used for updating specific fields
      );
      console.log("Updating user:", userId, "New username:", newUsername);
  
      // Check if a document was modified
      if (result.nModified === 0) {
        return res.status(404).json({ error: 'User not found or username unchanged' });
      }
  
      res.status(200).json({ message: 'Username updated successfully' });

    } catch (error) {
      console.error('Error updating username:', error);
      res.status(500).json({ error: 'Failed to update username' });
    }
  };

exports.updatePassword = async (req, res) => {
    try {
        const userId = req.params.userId;
        const { currentPassword, newPassword } = req.body; // Accept both current and new passwords

        if (!newPassword || !currentPassword) {
            return res.status(400).json({ error: 'Current and new passwords are required' });
        }

        // convert string to objectID
        // Deprecation does not apply to strings, just numbers, so no need to worry!
        const objectIdConversion = new mongoose.Types.ObjectId(userId);

        // Fetch user to verify current password
        const user = await User.findById(objectIdConversion);
        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        // compare current password w/ hashed password in DB
        const isMatch = await bcrypt.compare(currentPassword, user.password);
        if (!isMatch) {
            return res.status(400).json({ error: 'Current password is incorrect' });
        }
        // hash new password before saving
        const saltRounds = 10; // Salts create unique passwords, # of hashing rounds done. 
        const hashedPassword = await bcrypt.hash(newPassword, saltRounds);

        // Update the user's password in the database
        user.password = hashedPassword;
        await user.save();
        console.log("Updating user password:", userId, "New password:", newPassword);
        console.log("Hashed password:", hashedPassword);

        res.status(200).json({ message: 'Password updated successfully' });
    } catch (error) {
        console.error('Error updating password:', error);
        res.status(500).json({ error: 'Failed to update password.' });
    }
};
