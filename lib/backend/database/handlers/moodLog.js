const moodLogDao = require("../dao/moodLog");  // Import the mood log DAO
const userDao = require("../dao/user"); // Import the User DAO

// Handler to get all mood logs :)
exports.getAllMoodLogs = async (req, res) => {
    try {
        const moodLogs = await moodLogDao.getAllMoodLogs();
        if (!moodLogs || moodLogs.length === 0) return res.status(404).json({ message: 'No mood logs in collection' });
        res.json(moodLogs);
    } catch (err) {
        res.status(500).json({ message: 'Server Error' });
    }
};

// Handler to create a new mood log :)
exports.createMoodLog = async (req, res) => {
    const moodLogData = req.body;
    try {
      const requiredFields = ['user_id', 'mood', 'date', 'description']

      // Check for additional fields in the request body
      const extraFields = Object.keys(moodLogData).filter(field => !requiredFields.includes(field));

      if (extraFields.length > 0) {
          return res.status(400).json({ 
              message: 'Validation Error: Extra fields detected.', 
              extraFields 
          });
      }

      // Check if user exists
      const json_user = await userDao.getUserByID(moodLogData.user_id);
        
      if (!json_user) {
          return res.status(404).json({ message: 'User not found, mood log not created' });
      }
      console.log(moodLogData);

      const newMoodLog = await moodLogDao.createMoodLog(moodLogData);
      res.status(201).json(newMoodLog);

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

// Handler to get a mood log by ID :)
exports.getMoodLogByID = async (req, res) => {
    const moodLogId = req.params.id
    try {
        const moodLog = await moodLogDao.getMoodLogByID(moodLogId);
        if (!moodLog) return res.status(404).json({ message: 'mood log not found' });
        res.status(200).json(moodLog);
    } catch (err) {
        res.status(500).json({ message: 'Server Error' });
    }
};

// Handler to update a mood log by ID
exports.updateMoodLog = async (req, res) => {
    const moodLogId = req.params.id;  // Get the mood log ID from the URL
    const updateData = req.body;   // Get the data to update from the request body

    try {
      const requiredFields = ['user_id', 'mood', 'date', 'description']
      // Check for additional fields in the request body
      const extraFields = Object.keys(updateData).filter(field => !requiredFields.includes(field));

      if (extraFields.length > 0) {
          return res.status(400).json({ 
              message: 'Validation Error: Extra fields detected.', 
              extraFields 
          });
      }

      const updatedMoodLog = await moodLogDao.updateMoodLog(moodLogId, updateData);  // Update the mood log via the DAO
      if (!updatedMoodLog) {
          return res.status(404).json({ message: 'mood log not found' });
      }
      res.status(200).json({ message: 'mood log updated successfully', moodLog: updatedMoodLog });
  } catch (err) {
      res.status(500).json({ message: 'Error updating mood log', err: err.message });
  }
};

exports.deleteMoodLog = async (req,res) => {
    const moodLogId = req.params.id;
    try {
        const moodLog = await moodLogDao.deleteMoodLog(moodLogId);
        if (!moodLog) return res.status(404).json({ message: 'mood log not found' });
        res.status(200).json(moodLog);
    } catch(err) {
        res.status(500).json({ message: 'Error deleting mood log', err: err.message });
    }
}; 