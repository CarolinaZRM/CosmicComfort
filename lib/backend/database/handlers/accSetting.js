const accountSettingDao = require("../dao/accSetting");  // Import the account DAO
const accountDao = require("../dao/account");

// Handler to get all AccountSetting :)
exports.getAllAccountSettings = async (req, res) => {
    try {
        const accSetting = await accountSettingDao.getAllAccountSettings();
        if (!accSetting || accSetting.length === 0) return res.status(404).json({ message: 'No accountSetting in collection' });
        res.json(accSetting);
    } catch (err) {
        res.status(500).json({ message: "Error getting all accountSettings", err: err.message });
    }
};

// Handler to create a new AccountSetting :)
exports.createAccountSetting = async (req, res) => {
    const accSettingData = req.body;
    try {
        const requiredFields = ['acc_id','theme', 'font_size'];

        // Check for additional fields in the request body
        const extraFields = Object.keys(accSettingData).filter(field => !requiredFields.includes(field));

        if (extraFields.length > 0) {
            return res.status(400).json({ 
                message: 'Validation Error: Extra fields detected.', 
                extraFields 
            });
        }
        
        // Check if account exists
        const json_account = await accountDao.getAccountByID(accSettingData.acc_id);
        
        if (!json_account) {
            return res.status(404).json({ message: 'Account not found, accountSetting not created' });
        }
        console.log(accSettingData);
        const newAccountSetting = await accountSettingDao.createAccountSetting(accSettingData);
        res.status(201).json(newAccountSetting);

    } catch (err) {
        if (err.name === 'ValidationError') {
            const errors = Object.keys(err.errors).map(field => ({
                field,
                message: err.errors[field].message
            }));
            return res.status(400).json({ message: 'Validation Error', errors });
        }
        res.status(500).json({ message: "Error creating accountSetting", err: err.message });
    }
};

// Handler to get a Account by ID :)
exports.getAccountSettingByID = async (req, res) => {
    const accountSettingId = req.params.id
    try {
        const accountSetting = await accountSettingDao.getAccountSettingByID(accountSettingId);
        if (!accountSetting) return res.status(404).json({ message: 'accountSetting not found' });
        res.status(200).json(accountSetting);
    } catch (err) {
        res.status(500).json({ message: "Error getting accountSetting", err: err.message });
    }
};

// Handler to update a Account by ID :)
exports.updateAccountSetting = async (req, res) => {
    const accountSettingId = req.params.id;  // Get the account ID from the URL
    const updateData = req.body;   // Get the data to update from the request body
    try {
      const requiredFields = ['acc_id','theme', 'font_size'];

      // Check for additional fields in the request body
      const extraFields = Object.keys(updateData).filter(field => !requiredFields.includes(field));

      if (extraFields.length > 0) {
          return res.status(400).json({ 
              message: 'Validation Error: Extra fields detected.', 
              extraFields 
          });
      }
      
      // Check if user exists
      const json_account = await accountDao.getAccountByID(updateData.acc_id);
      if (!json_account) {
          return res.status(404).json({ message: 'Account not found, accountSetting not updated' });
      }

      // Check if json user matches account user
      const temp_accSetting = await accountSettingDao.getAccountSettingByID(accountSettingId);

      if (String(json_account._id) !== String(temp_accSetting.acc_id)) {
          return res.status(400).json({ 
              //message: `User ID mismatch: ${updateData.user_id} does not match the account's user ID: ${temp_acc.user_id}`
              message: 'Account ID mismatch: json acc_id doesn\'t belong to account'
          });
      }

      // Ensure user_id is not modified
      delete updateData.acc_id;
      
      // Update the account via the DAO
      const updatedAccountSetting = await accountSettingDao.updateAccountSetting(accountSettingId, updateData);  
      if (!updatedAccountSetting) {
          return res.status(404).json({ message: 'accountSetting not found' });
      }
      res.status(200).json({ message: 'accountSetting updated successfully', accountSetting: updatedAccountSetting });
    } catch (err) {
        res.status(500).json({ message: 'Error updating accountSetting', err: err.message });
    }
};

// Handler to delete a Account by ID :)
exports.deleteAccountSetting = async (req,res) => {
    const accountSettingId = req.params.id;
    try {
        const accountSetting = await accountSettingDao.deleteAccountSetting(accountSettingId);
        if (!accountSetting) return res.status(404).json({ message: 'accountSetting not found' });
        res.status(200).json(accountSetting);
    } catch(err) {
        res.status(500).json({ message: 'Error deleting accountSetting', err: err.message });
    }
}; 