const FakeCall = require("../models").fakeCall

exports.getAllFakeCalls = async () => {
    return await FakeCall.find({});
};
  
  // Function to create a new fakeCall
exports.createFakeCall = async (FakeCallData) => {
    const newFakeCall = new FakeCall(FakeCallData);
    return await newFakeCall.save();
};

exports.getFakeCallByID = async (fakeCallId) => {
    return await FakeCall.findById(fakeCallId);
}

exports.updateFakeCall = async (fakeCallId, updateData) => {
    return await FakeCall.findByIdAndUpdate(fakeCallId, updateData, { new: true });
}

exports.deleteFakeCall = async (fakeCallId) => {
    return await FakeCall.findByIdAndDelete(fakeCallId);
}

exports.getFakeCallByUserId = async (userId) => {
    return await FakeCall.findOne({ user_id: userId });
}