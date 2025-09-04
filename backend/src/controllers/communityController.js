const NGO = require('../models/NGO');
const CommunityReport = require('../models/CommunityReport');

exports.listNGOs = async (req, res, next) => {
  try {
    const ngos = await NGO.find({}).sort({ name: 1 });
    res.json({ ngos });
  } catch (err) { next(err); }
};

exports.createReport = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    const { description, lat, lng, anonymous = false } = req.body || {};
    if (!description || String(description).trim().length < 5) {
      return res.status(400).json({ message: 'description must be at least 5 characters' });
    }

    const doc = await CommunityReport.create({
      user: anonymous ? undefined : userId,
      anonymous: Boolean(anonymous),
      description: String(description).trim(),
      location: lat != null && lng != null
        ? { type: 'Point', coordinates: [Number(lng), Number(lat)] }
        : undefined,
    });

    res.status(201).json({ report: doc });
  } catch (err) { next(err); }
};

