// Trivial console-based notifier. Replace with FCM/APNS/OneSignal/etc.
exports.sendPushNotification = async (to, payload) => {
  if (!to) return { ok: false, error: 'missing_recipient' };
  console.log('Push →', { to, payload });
  return { ok: true, provider: 'console' };
};

// Naive risk scoring:
// - if isDangerZone: +50
// - if location within bbox [lng between 72..73 and lat between 18..19] add +20
// - cap to 100
exports.computePredictiveAlerts = async (locationDoc) => {
  if (!locationDoc) return { riskScore: 0 };
  let score = 0;
  if (locationDoc.isDangerZone) score += 50;
  const [lng, lat] = locationDoc.coordinates?.coordinates || [];
  if (
    typeof lat === 'number' && typeof lng === 'number' &&
    lng >= 72 && lng <= 73 && lat >= 18 && lat <= 19
  ) {
    score += 20;
  }
  if (typeof locationDoc.predictedRiskScore === 'number') {
    score = Math.max(score, locationDoc.predictedRiskScore);
  }
  return { riskScore: Math.max(0, Math.min(100, score)) };
};

const User = require('../models/User');
exports.notifyContacts = async (userId, location, payload) => {
  const user = await User.findById(userId).select('trustedContacts name');
  if (!user?.trustedContacts?.length) return { ok: true, sent: 0 };
  const enriched = { ...payload, location, user: { id: String(user._id), name: user.name } };
  const results = await Promise.all(
    user.trustedContacts.map(c => exports.sendPushNotification(c.phone || c.email, enriched))
  );
  return { ok: true, sent: results.length };
};

