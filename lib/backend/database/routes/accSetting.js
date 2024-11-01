const express = require('express');
const router = express.Router();
const accountSettingHandler = require('../handlers/accSetting');

// Route to get all users
router.get('/', accountSettingHandler.getAllAccountSettings);

// Route to create a new user
router.post('/', accountSettingHandler.createAccountSetting);

// Route to get a user by ID
router.get('/:id', accountSettingHandler.getAccountSettingByID);

// Route to update a user by ID
router.put('/:id', accountSettingHandler.updateAccountSetting);

// Route to delte a user by ID
router.delete('/:id', accountSettingHandler.deleteAccountSetting);

// Export the router
module.exports = router;