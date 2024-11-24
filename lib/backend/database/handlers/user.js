const userDao = require("../dao/user");  // Import the User DAO

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
        const user = await userDao.loginUser(username, password);
        console.log("user fetched from DAO:", user);

        if (!user){
            return res.status(404).json({message: "Invalid username or password."})
        }

        return res.json({message: "Login Successful", user});
    } catch (err) {
        console.error("Error in loginUser handler:", err)
        res.status(500).json({message: "Server Error,", error: err.message});
    }

}

// exports.comparePassword = async (userPassword) => {
//     try{
//         const isMatch = await bcrypt.compare(userPassword, this.password);
//         return isMatch;
//     } catch(err) {
//         throw(err);
//     }

// }
// const User = mongoose.model('User', userSchema);

// exports.getUserByID = async (req, res) => {
//     const userId = req.params.id
//     try {
//         const user = await userDao.getUserByID(userId);
//         if (!user) return res.status(404).json({ message: 'User not found' });
//         res.status(200).json(user);
//     } catch (err) {
//         res.status(500).json({ message: 'Server Error' });
//     }
// };
