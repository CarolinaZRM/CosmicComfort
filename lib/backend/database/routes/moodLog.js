const express = require('express');
const router = express.Router();
const moodLogHandler = require('../handlers/moodLog');  // Import the fake call handler

// Route to get all fake calls
router.get('/', moodLogHandler.getAllMoodLogs);

// Route to create a new fake call
router.post('/', moodLogHandler.createMoodLog);

// Route to get a fake call by ID
router.get('/:id', moodLogHandler.getMoodLogByID);

// Route to update a fake call by ID
router.put('/:id', moodLogHandler.updateMoodLog);

// Route to delte a fake call by ID
router.delete('/:id', moodLogHandler.deleteMoodLog);

// Export the router
module.exports = router;