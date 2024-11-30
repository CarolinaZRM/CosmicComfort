const express = require('express');
const router = express.Router();
const accountSettingHandler = require('../handlers/accSetting');

// Route to get all users
router.get('/', accountSettingHandler.getAllAccountSettings);

// Route to create a new user
router.post('/', accountSettingHandler.createAccountSetting);

// Route to get a accountSetting by ID
router.get('/:id', accountSettingHandler.getAccountSettingByID);

// Route to update a accountSetting by ID
router.put('/:id', accountSettingHandler.updateAccountSetting);

// Route to update a accountSetting by user_id
router.put('/user/:id', accountSettingHandler.updateAccountSettingByUserId);

// Route to get accountSetting of a user using their user_id
router.get('/user/:id', accountSettingHandler.getAccountSettingByUserId);

// Route to delte a accountSetting by ID
router.delete('/:id', accountSettingHandler.deleteAccountSetting);


// Export the router
module.exports = router;