const accountDao = require("../dao/account");  // Import the account DAO
const userDao = require("../dao/user");

// Handler to get all Account :)
exports.getAllAccounts = async (req, res) => {
    try {
        const account = await accountDao.getAllAccounts();
        if (!account || account.length === 0) return res.status(404).json({ message: 'No account in collection' });
        res.json(account);
    } catch (err) {
        res.status(500).json({ message: "Error getting all accounts", err: err.message });
    }
};

// Handler to create a new Account :)
exports.createAccount = async (req, res) => {
    const accountData = req.body;
    try {
        const requiredFields = ['user_id','display_name', 'email', 'password'];

        // Check for additional fields in the request body
        const extraFields = Object.keys(accountData).filter(field => !requiredFields.includes(field));

        if (extraFields.length > 0) {
            return res.status(400).json({ 
                message: 'Validation Error: Extra fields detected.', 
                extraFields 
            });
        }
        
        // Check if user exists
        const json_user = await userDao.getUserByID(accountData.user_id);
        
        if (!json_user) {
            return res.status(404).json({ message: 'User not found, account not created' });
        }


        // Set date_created to the current date and time, its formatted as such: "2024-10-22T14:30:00Z"
        accountData.date_created = new Date();

        const newAccount = await accountDao.createAccount(accountData);
        res.status(201).json(newAccount);
    } catch (err) {
        if (err.name === 'ValidationError') {
            const errors = Object.keys(err.errors).map(field => ({
                field,
                message: err.errors[field].message
            }));
            return res.status(400).json({ message: 'Validation Error', errors });
        }
        res.status(500).json({ message: "Error creating account", err: err.message });
    }
};

// Handler to get a Account by ID :)
exports.getAccountByID = async (req, res) => {
    const accountId = req.params.id
    try {
        const account = await accountDao.getAccountByID(accountId);
        if (!account) return res.status(404).json({ message: 'account not found' });
        res.status(200).json(account);
    } catch (err) {
        res.status(500).json({ message: "Error getting account", err: err.message });
    }
};

// Handler to update a Account by ID :)
exports.updateAccount = async (req, res) => {
    const accountId = req.params.id;  // Get the account ID from the URL
    const updateData = req.body;   // Get the data to update from the request body
    try {
        const requiredFields = ['user_id', 'display_name', 'email', 'password'];
        // Check for additional fields in the request body
        const extraFields = Object.keys(updateData).filter(field => !requiredFields.includes(field));

        if (extraFields.length > 0) {
            return res.status(400).json({ 
                message: 'Validation Error: Extra fields detected.', 
                extraFields 
            });
        }
        
        // Check if user exists
        const json_user = await userDao.getUserByID(updateData.user_id);
        if (!json_user) {
            return res.status(404).json({ message: 'User not found, account not updated' });
        }

        // Check if json user matches account user
        const temp_acc = await accountDao.getAccountByID(accountId);

        if (String(json_user._id) !== String(temp_acc.user_id)) {
            return res.status(400).json({ 
                //message: `User ID mismatch: ${updateData.user_id} does not match the account's user ID: ${temp_acc.user_id}`
                message: 'User ID mismatch: json user_id doesn\'t belong to account'
            });
        }


        // Ensure user_id is not modified
        delete updateData.user_id;
        
        // Update the account via the DAO
        const updatedAccount = await accountDao.updateAccount(accountId, updateData);  
        if (!updatedAccount) {
            return res.status(404).json({ message: 'account not found' });
        }
        res.status(200).json({ message: 'account updated successfully', account: updatedAccount });
    } catch (err) {
        res.status(500).json({ message: 'Error updating account', err: err.message });
    }
};

// Handler to delete a Account by ID :)
exports.deleteAccount = async (req,res) => {
    const accountId = req.params.id;
    try {
        const account = await accountDao.deleteAccount(accountId);
        if (!account) return res.status(404).json({ message: 'account not found' });
        res.status(200).json(account);
    } catch(err) {
        res.status(500).json({ message: 'Error deleting account', err: err.message });
    }
}; 