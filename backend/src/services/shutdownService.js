const User = require('../models/User');
const SOSLog = require('../models/SOSLog');
const alertService = require('./alertService');

// Stub: could implement OS signals handling or Android device admin policies.
exports.preventShutdown = async () => {
  return { enabled: true };
};

exports.verifyAntiShutdownPassword = async (userId, password) => {
  const user = await User.findById(userId).select('antiShutdownPassword');
  if (!user) throw Object.assign(new Error('User not found'), { status: 404 });
  return String(user.antiShutdownPassword || '') === String(password || '');
};

exports.handleShutdownAttempt = async (userId, location) => {
  // find active sos for the user
  const sos = await SOSLog.findOne({ user: userId, active: true }).sort({ createdAt: -1 });
  if (sos) {
    sos.shutdownAttempt = new Date();
    await sos.save();
    await alertService.notifyContacts(userId, location, {
      type: 'shutdown_attempt',
      message: 'Possible forced shutdown detected!',
    });
  }
  return { status: 'alert_sent' };
};

