const fakeCallDao = require("../dao/fakeCall");  // Import the Fake Call DAO
const userDao = require("../dao/user"); // Import the User DAO

// Handler to get all fake calls :)
exports.getAllFakeCalls = async (req, res) => {
    try {
        const fakeCalls = await fakeCallDao.getAllFakeCalls();
        if (!fakeCalls || fakeCalls.length === 0) return res.status(404).json({ message: 'No fake calls in collection' });
        res.json(fakeCalls);
    } catch (err) {
        res.status(500).json({ message: 'Server Error' });
    }
};

// Handler to create a new fake call :)
exports.createFakeCall = async (req, res) => {
    const fakeCallData = req.body;
    try {
      const requiredFields = ['user_id', 'caller_name', 'call_time', 'ringtone', 'ring_name']

      // Check for additional fields in the request body
      const extraFields = Object.keys(fakeCallData).filter(field => !requiredFields.includes(field));

      if (extraFields.length > 0) {
          return res.status(400).json({ 
              message: 'Validation Error: Extra fields detected.', 
              extraFields 
          });
      }

      // Check if user exists
      const json_user = await userDao.getUserByID(fakeCallData.user_id);
        
      if (!json_user) {
          return res.status(404).json({ message: 'User not found, fake call not created' });
      }
      console.log(fakeCallData);

      const newFakeCall = await fakeCallDao.createFakeCall(fakeCallData);
      res.status(201).json(newFakeCall);

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

// Handler to get a fake call by ID :)
exports.getFakeCallByID = async (req, res) => {
    const fakeCallId = req.params.id
    try {
        const fakeCall = await fakeCallDao.getFakeCallByID(fakeCallId);
        if (!fakeCall) return res.status(404).json({ message: 'Fake Call not found' });
        res.status(200).json(fakeCall);
    } catch (err) {
        res.status(500).json({ message: 'Server Error' });
    }
};

// Handler to update a fake call by ID
exports.updateFakeCall = async (req, res) => {
    const fakeCallId = req.params.id;  // Get the fake call ID from the URL
    const updateData = req.body;   // Get the data to update from the request body

    try {
      const requiredFields = ['user_id', 'caller_name', 'call_time', 'ringtone', 'ring_name']
      // Check for additional fields in the request body
      const extraFields = Object.keys(updateData).filter(field => !requiredFields.includes(field));

      if (extraFields.length > 0) {
          return res.status(400).json({ 
              message: 'Validation Error: Extra fields detected.', 
              extraFields 
          });
      }

      const updatedFakeCall = await fakeCallDao.updateFakeCall(fakeCallId, updateData);  // Update the fake call via the DAO
      if (!updatedFakeCall) {
          return res.status(404).json({ message: 'Fake Call not found' });
      }
      res.status(200).json({ message: 'Fake Call updated successfully', fakeCall: updatedFakeCall });
  } catch (err) {
      res.status(500).json({ message: 'Error updating fake call', err: err.message });
  }
};

exports.deleteFakeCall = async (req,res) => {
    const fakeCallId = req.params.id;
    try {
        const fakeCall = await fakeCallDao.deleteFakeCall(fakeCallId);
        if (!fakeCall) return res.status(404).json({ message: 'Fake Call not found' });
        res.status(200).json(fakeCall);
    } catch(err) {
        res.status(500).json({ message: 'Error deleting fake call', err: err.message });
    }
}; 