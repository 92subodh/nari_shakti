const Location = require('../models/Location');
const alertService = require('../services/alertService');

exports.liveTracking = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    if (!userId) return res.status(401).json({ message: 'Unauthorized' });

    const { lat, lng, isDangerZone } = req.query;
    if (lat && lng) {
      await Location.create({
        user: userId,
        coordinates: { type: 'Point', coordinates: [Number(lng), Number(lat)] },
        isDangerZone: Boolean(isDangerZone === 'true' || isDangerZone === true),
      });
    }

    const latest = await Location.findOne({ user: userId }).sort({ createdAt: -1 });
    const predictive = latest ? await alertService.computePredictiveAlerts(latest) : { riskScore: 0 };
    return res.json({ latest, predictive });
  } catch (err) {
    next(err);
  }
};

