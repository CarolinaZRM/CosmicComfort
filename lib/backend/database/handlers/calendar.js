const calendarDao = require("../dao/calendar");  // Import the Calendar DAO
const userDao = require("../dao/user"); // Import the User DAO

// Handler to get all Calendars :)
exports.getAllCalendars = async (req, res) => {
    try {
        const calendars = await calendarDao.getAllCalendars();
        if (!calendars || calendars.length === 0) return res.status(404).json({ message: 'No Calendars in collection' });
        res.json(calendars);
    } catch (err) {
        res.status(500).json({ message: 'Server Error' });
    }
};

// Handler to create a new Calendar :)
exports.createCalendar = async (req, res) => {
    const calendarData = req.body;
    try {
      const requiredFields = ['user_id', 'mood_list', 'date_colors']

      // Check for additional fields in the request body
      const extraFields = Object.keys(calendarData).filter(field => !requiredFields.includes(field));

      if (extraFields.length > 0) {
          return res.status(400).json({ 
              message: 'Validation Error: Extra fields detected.', 
              extraFields 
          });
      }

      // Check if user exists
      const json_user = await userDao.getUserByID(calendarData.user_id);
        
      if (!json_user) {
          return res.status(404).json({ message: 'User not found, Calendar not created' });
      }
      console.log(calendarData);

      const newCalendar = await calendarDao.createCalendar(calendarData);
      res.status(201).json(newCalendar);

    } catch (err) {
        if (err.name === 'ValidationError') {
            const errors = Object.keys(err.errors).map(field => ({
                field,
                message: err.errors[field].message
            }));
            return res.status(400).json({ message: 'Validation Error', errors });
        }
        res.status(500).json({ message: 'Server Error' });
    }
};

// Handler to get a Calendar by ID :)
exports.getCalendarByID = async (req, res) => {
    const calendarId = req.params.id
    try {
        const calendar = await calendarDao.getCalendarByID(calendarId);
        if (!calendar) return res.status(404).json({ message: 'Calendar not found' });
        res.status(200).json(calendar);
    } catch (err) {
        res.status(500).json({ message: 'Server Error' });
    }
};

// Handler to update a Calendar by ID
exports.updateCalendar = async (req, res) => {
    const calendarId = req.params.id;  // Get the Calendar ID from the URL
    const updateData = req.body;   // Get the data to update from the request body

    try {
      const requiredFields = ['user_id', 'mood_list', 'date_colors']


      // Check for additional fields in the request body
      const extraFields = Object.keys(updateData).filter(field => !requiredFields.includes(field));

      if (extraFields.length > 0) {
          return res.status(400).json({ 
              message: 'Validation Error: Extra fields detected.', 
              extraFields 
          });
      }

      const updatedCalendar = await calendarDao.updateCalendar(calendarId, updateData);  // Update the Calendar via the DAO
      if (!updatedCalendar) {
          return res.status(404).json({ message: 'Calendar not found' });
      }
      res.status(200).json({ message: 'Calendar updated successfully', calendar: updatedCalendar });
  } catch (err) {
      res.status(500).json({ message: 'Error updating Calendar', err: err.message });
  }
};

exports.deleteCalendar = async (req,res) => {
    const calendarId = req.params.id;
    try {
        const calendar = await calendarDao.deleteCalendar(calendarId);
        if (!calendar) return res.status(404).json({ message: 'Calendar not found' });
        res.status(200).json(calendar);
    } catch(err) {
        res.status(500).json({ message: 'Error deleting Calendar', err: err.message });
    }
}; 

exports.getCalendarByUserId = async (req,res) => {
    const user_id = req.params.id;
    try {
        const calendar = await calendarDao.getCalendarByUserId(user_id);
        if (!calendar) return res.status(404).json({ message: 'Calendar for this user not found' });
        res.status(200).json(calendar);
    } catch (err) {
        res.status(500).json({ message: "Error getting calendar", err: err.message });
    }

};

exports.updateCalendarByUserId = async (req, res) => {
    const userId = req.params.id;  // Get the user ID from the URL
    const updateData = req.body;   // Get the data to update from the request body
    try {
        const requiredFields = ['user_id', 'mood_list', 'date_colors']


        // Check for additional fields in the request body
        const extraFields = Object.keys(updateData).filter(field => !requiredFields.includes(field));

        if (extraFields.length > 0) {
            return res.status(400).json({ 
                message: 'Validation Error: Extra fields detected.', 
                extraFields 
            });
        }

        // Check if user exists
        const json_user = await userDao.getUserByID(userId);

        if (!json_user) {
            return res.status(404).json({ message: 'User not found, calendar not updated' });
        }

        // Find calendar of user
        const calendar = await calendarDao.getCalendarByUserId(userId);
        if (!calendar) {
            return res.status(404).json({ message: 'Calendar not found for this user' });
        }

        calendarId = calendar._id;

        // Update the calendar via the DAO
        const updatedCalendar = await calendarDao.updateCalendar(calendarId, updateData);  
        if (!updatedCalendar) {
            return res.status(404).json({ message: 'Calendar not found' });
        }
        res.status(200).json({ message: 'Calendar updated successfully', calendar: updatedCalendar });
        } catch (err) {
        res.status(500).json({ message: 'Error updating calendar', err: err.message });
        }
};

exports.addOrUpdateMoodLog = async (req, res) => {
    console.log(req.body.date_colors);
    const userId = req.params.userId; // The user ID
    const { date, mood, description, color } = req.body; // Data for the mood log

    if (!date || !color) {
        return res.status(400).json({ message: 'Validation Error: "date" and "color" are required.' });
    }

    try {
        const calendar = await calendarDao.getCalendarByUserId(userId);
        if (!calendar) {
            return res.status(404).json({ message: 'Calendar not found for this user.' });
        }

        await calendarDao.addOrUpdateMoodLog(userId, date, color, mood, description);
        res.status(200).json({ message: 'Mood log added or updated successfully.' });
    } catch (error) {
        res.status(500).json({ message: 'Error adding or updating mood log', error: error.message });
    }
};