const express = require('express');
const router = express.Router();
const CalendarHandler = require('../handlers/calendar');  // Import the Calendar handler

// Route to get all Calendars
router.get('/', CalendarHandler.getAllCalendars);

// Route to create a new Calendar
router.post('/', CalendarHandler.createCalendar);

// Route to get a Calendar by ID
router.get('/:id', CalendarHandler.getCalendarByID);

// Route to update a Calendar by ID
router.put('/:id', CalendarHandler.updateCalendar);

// Route to delte a Calendar by ID
router.delete('/:id', CalendarHandler.deleteCalendar);

// Route to update a accountSetting by user_id
router.put('/user/:id', CalendarHandler.updateCalendarByUserId);

// Route to get accountSetting of a user using their user_id
router.get('/user/:id', CalendarHandler.getCalendarByUserId);

router.put('/user/mood_log/:id', CalendarHandler.addOrUpdateMoodLog);

// Export the router
module.exports = router;