const express = require('express');
const router = express.Router();
const reminderHandler = require('../handlers/selfcareReminders');  // Import the user handler

// Route to get all reminders
router.get('/', reminderHandler.getAllReminders);

// Route to create a new reminder
router.post('/', reminderHandler.createReminder);

// Route to get a reminder by ID
router.get('/:id', reminderHandler.getReminderByID);

// Route to update a reminder by ID
router.put('/:id', reminderHandler.updateReminder);

// Route to update a reminder by title and user_id
router.put('/user/:id', reminderHandler.updateReminderByIdAndTitle);

// Route to delete a reminder by ID
router.delete('/:id', reminderHandler.deleteReminder);

//route to delete a reminder by title and user_id
router.delete('/user/:id', reminderHandler.deleteReminderByIdTitle);

// Export the router
module.exports = router;