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

// Export the router
module.exports = router;