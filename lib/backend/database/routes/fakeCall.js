const express = require('express');
const router = express.Router();
const fakeCallHandler = require('../handlers/fakeCall');  // Import the fake call handler

// Route to get all fake calls
router.get('/', fakeCallHandler.getAllFakeCalls);

// Route to create a new fake call
router.post('/', fakeCallHandler.createFakeCall);

// Route to get a fake call by ID
router.get('/:id', fakeCallHandler.getFakeCallByID);

// Route to update a fake call by ID
router.put('/:id', fakeCallHandler.updateFakeCall);

// Route to delte a fake call by ID
router.delete('/:id', fakeCallHandler.deleteFakeCall);

// Export the router
module.exports = router;