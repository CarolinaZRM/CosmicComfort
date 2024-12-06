const reminderDao = require("../dao/selfcareReminders");  // Import the reminder DAO
const userDao = require("../dao/user"); // Import the User DAO

// Handler to get all reminders :)
exports.getAllReminders = async (req, res) => {
    try {
        const reminders = await reminderDao.getAllReminders();
        if (!reminders || reminders.length === 0) return res.status(404).json({ message: 'No reminders in collection' });
        res.json(reminders);
    } catch (err) {
        res.status(500).json({ message: 'Server Error' });
    }
};

// Handler to get all reminders :)
exports.getAllUserReminders = async (req, res) => {
  const userId = req.params.id
  try {
      const reminders = await reminderDao.getAllUserReminders(userId);
      if (!reminders || reminders.length === 0) return res.status(404).json({ message: 'No user reminders in collection' });
      res.json(reminders);
  } catch (err) {
      res.status(500).json({ message: 'Server Error' });
  }
};

// Handler to create a new reminder :)
exports.createReminder = async (req, res) => {
    const reminderData = req.body;
    try {
      const requiredFields = ['user_id', 'title', 'body', 'start_datetime', 'reminder_type', 'interval_type', 'interval']

      // Check for additional fields in the request body
      const extraFields = Object.keys(reminderData).filter(field => !requiredFields.includes(field));

      if (extraFields.length > 0) {
          return res.status(400).json({ 
              message: 'Validation Error: Extra fields detected.', 
              extraFields 
          });
      }
    
      // Validate if unique!
      const tempReminder = await reminderDao.getReminderByUserIdAndTitle(reminderData.user_id, reminderData.title);
      if (tempReminder) {
        return res.status(400).json({ 
            message: 'Validation Error: Existing reminder of same title found!.',  
        });
      }

      // Validate interval types!
      const validIntervalType = ["daily", "hourly", "weekly", "monthly"];
      const intervalType = reminderData.interval_type;
      if (!validIntervalType.includes(intervalType)) {
        return res.status(400).json({ 
            message: 'Validation Error: interval type must be: "daily", "hourly", "weekly", or "monthly"'
        });
      }

      // Check if user exists
      const json_user = await userDao.getUserByID(reminderData.user_id);
        
      if (!json_user) {
          return res.status(404).json({ message: 'User not found, reminder not created' });
      }
      console.log(reminderData);



      const newreminder = await reminderDao.createReminder(reminderData);
      res.status(201).json(newreminder);

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

// Handler to get a reminder by ID :)
exports.getReminderByID = async (req, res) => {
    const reminderId = req.params.id
    try {
        const reminder = await reminderDao.getReminderByID(reminderId);
        if (!reminder) return res.status(404).json({ message: 'Reminder not found' });
        res.status(200).json(reminder);
    } catch (err) {
        res.status(500).json({ message: 'Server Error' });
    }
};

// Handler to update a reminder by ID :)
exports.updateReminder = async (req, res) => {
    const reminderId = req.params.id;  // Get the reminder ID from the URL
    const updateData = req.body;   // Get the data to update from the request body

    try {
      const requiredFields = ['user_id', 'title', 'body', 'start_datetime', 'reminder_type', 'interval_type', 'interval']
      // Check for additional fields in the request body
      const extraFields = Object.keys(updateData).filter(field => !requiredFields.includes(field));

      if (extraFields.length > 0) {
          return res.status(400).json({ 
              message: 'Validation Error: Extra fields detected.', 
              extraFields 
          });
      }

      const validIntervalType = ["daily", "hourly", "weekly", "monthly"];
      const intervalType = updateData.interval_type;
      if (!validIntervalType.includes(intervalType)) {
        return res.status(400).json({ 
            message: 'Validation Error: interval type must be: "daily", "hourly", "weekly", or "monthly"'
        });
      }

      const updatedReminder = await reminderDao.updateReminder(reminderId, updateData);  // Update the mood log via the DAO
      if (!updatedReminder) {
          return res.status(404).json({ message: 'Reminder not found' });
      }
      res.status(200).json({ message: 'Reminder updated successfully', reminder: updatedReminder });
    } catch (err) {
      res.status(500).json({ message: 'Error updating mood log', err: err.message });
    }
};

// update reminder by user_id and title! :)
exports.updateReminderByIdAndTitle = async (req, res) => {
    const userId = req.params.id;
    const updateData = req.body;   
    try {
      const requiredFields = ['old_title', 'title', 'body', 'start_datetime', 'reminder_type', 'interval_type', 'interval']
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
      console.log(json_user);
      if (!json_user) {
          return res.status(404).json({ message: 'User not found, reminder not updated' });
      }

      // get the reminder to be updated
      const reminderToUpdate = await reminderDao.getReminderByUserIdAndTitle(userId, updateData.old_title);
      if (!reminderToUpdate) {
          return res.status(404).json({ message: 'Reminder not found' });
      }

      const validIntervalType = ["daily", "hourly", "weekly", "monthly"];
      const intervalType = updateData.interval_type;
      if (!validIntervalType.includes(intervalType)) {
        return res.status(400).json({ 
            message: 'Validation Error: interval type must be: "daily", "hourly", "weekly", or "monthly"'
        });
      }

      // Discard old_title data and update
      delete updateData.old_title;
      const updatedReminder = await reminderDao.updateReminder(reminderToUpdate._id, updateData);
      if (!updatedReminder) {
        return res.status(404).json({ message: 'Reminder not found' });
      }
      res.status(200).json({ message: 'Reminder updated successfully', reminder: updatedReminder });
    } catch (err) {
      res.status(500).json({ message: 'Error updating reminder', err: err.message });
    }

}

// Delete reminder by user_id and title
exports.deleteReminderByIdTitle = async (req,res) => {
    const user_id = req.params.id;
    const jsonData = req.body;
   
    try { 
      const requiredFields = ['title']
      // Check for additional fields in the request body
      const extraFields = Object.keys(jsonData).filter(field => !requiredFields.includes(field));

      if (extraFields.length > 0) {
        return res.status(400).json({ 
          message: 'Validation Error: Extra fields detected.', 
          extraFields 
        });
      }

      // Check if the request body is empty
      if (Object.keys(jsonData).length === 0) {
        return res.status(400).json({ message: 'No JSON data found in the request body' });
      }
      
      // Delete the reminder!
      const title = jsonData.title;
      const reminderToDel = await reminderDao.getReminderByUserIdAndTitle(user_id, title)
      if (!reminderToDel) return res.status(404).json({ message: 'reminder not found' });
      const reminder = await reminderDao.deleteReminder(reminderToDel._id);
      if (!reminder) return res.status(404).json({ message: 'reminder not found' });
      res.status(200).json(reminder);
    } catch(err) {
      res.status(500).json({ message: 'Error deleting reminder', err: err.message });
    }
}

// Delete reminder!
exports.deleteReminder = async (req,res) => {
    const reminderId = req.params.id;
    try {
        const reminder = await reminderDao.deleteReminder(reminderId);
        if (!reminder) return res.status(404).json({ message: 'reminder not found' });
        res.status(200).json(reminder);
    } catch(err) {
        res.status(500).json({ message: 'Error deleting reminder', err: err.message });
    }
}; 