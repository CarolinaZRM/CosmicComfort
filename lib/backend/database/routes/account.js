const express = require('express');
const router = express.Router();
const accountHandler = require('../handlers/account');  // Import the user handler

// Route to get all users
router.get('/', accountHandler.getAllAccounts);

// Route to create a new user
router.post('/', accountHandler.createAccount);

// Route to get a user by ID
router.get('/:id', accountHandler.getAccountByID);

// Route to update a user by ID
router.put('/:id', accountHandler.updateAccount);

// Route to delte a user by ID
router.delete('/:id', accountHandler.deleteAccount);

// Export the router
module.exports = router;