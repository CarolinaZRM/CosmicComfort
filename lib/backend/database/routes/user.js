const express = require('express');
const router = express.Router();
const userHandler = require('../handlers/user');  // Import the user handler

// Route to get all users
router.get('/', userHandler.getAllUsers);

// Route to create a new user
router.post('/', userHandler.createUser);

// Route to get a user by ID
router.get('/:id', userHandler.getUserByID);

// Route to update a user by ID
router.put('/:id', userHandler.updateUser);

// Route to delte a user by ID
router.delete('/:id', userHandler.deleteUser);

// Route to log user in
router.post('/login', userHandler.loginUser);

// Route to authenticate token
router.get('/protected-route', userHandler.authenticateToken);

// Route to update username
router.patch('/update-username/:userId', userHandler.updateUsername);

// Route to update password
router.patch('/update-password/:userId', userHandler.updatePassword);

// Route to update profile picture
router.patch('/update-profpic/:userId', userHandler.updateProfilePicture);

// Export the router
module.exports = router;