const SOSLog = require('../models/SOSLog');
const sosService = require('../services/sosService');

exports.startSOS = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    if (!userId) return res.status(401).json({ message: 'Unauthorized' });

    const serviceResult = await sosService.start(userId);
    const log = await SOSLog.create({ user: userId, status: 'started', active: true });
    return res.status(201).json({ sos: serviceResult, logId: log._id });
  } catch (err) {
    next(err);
  }
};

exports.endSOS = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    if (!userId) return res.status(401).json({ message: 'Unauthorized' });

    const serviceResult = await sosService.stop(userId);
    const log = await SOSLog.findOneAndUpdate(
      { user: userId, active: true },
      { status: 'ended', active: false, endedAt: new Date() },
      { new: true }
    );
    return res.json({ sos: serviceResult, log });
  } catch (err) {
    next(err);
  }
};

