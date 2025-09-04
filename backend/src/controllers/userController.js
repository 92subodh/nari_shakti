const User = require('../models/User');
const shutdownService = require('../services/shutdownService');

exports.updateTrustedContacts = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    const { contacts } = req.body;
    if (!userId) return res.status(401).json({ message: 'Unauthorized' });
    if (!Array.isArray(contacts)) return res.status(400).json({ message: 'contacts must be an array' });

    const sanitized = contacts
      .filter(Boolean)
      .map(c => ({ name: String(c.name || '').trim(), phone: String(c.phone || '').trim() }))
      .filter(c => c.name && c.phone);

    const updated = await User.findByIdAndUpdate(
      userId,
      { trustedContacts: sanitized },
      { new: true }
    ).select('trustedContacts');

    return res.json({ trustedContacts: updated?.trustedContacts || [] });
  } catch (err) {
    next(err);
  }
};

exports.setSafeWord = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    const { safeWord } = req.body;
    if (!userId) return res.status(401).json({ message: 'Unauthorized' });
    if (!safeWord || String(safeWord).trim().length < 3) {
      return res.status(400).json({ message: 'safeWord must be at least 3 characters' });
    }

    await User.findByIdAndUpdate(userId, { safeWord: String(safeWord).trim() });
    return res.json({ ok: true });
  } catch (err) {
    next(err);
  }
};

exports.shutdownAttempt = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    const { lat, lng } = req.body || {};
    if (!userId) return res.status(401).json({ message: 'Unauthorized' });
    const location = (lat != null && lng != null) ? { lat: Number(lat), lng: Number(lng) } : undefined;
    const result = await shutdownService.handleShutdownAttempt(userId, location);
    res.json(result);
  } catch (err) { next(err); }
};

exports.verifyShutdown = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    const { password } = req.body || {};
    if (!userId) return res.status(401).json({ message: 'Unauthorized' });
    const ok = await shutdownService.verifyAntiShutdownPassword(userId, password);
    res.json({ ok });
  } catch (err) { next(err); }
};

