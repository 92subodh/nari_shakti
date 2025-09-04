const Media = require('../models/Media');
const mediaService = require('../services/mediaService');

exports.uploadEvidence = async (req, res, next) => {
  try {
    const userId = req.user?.id;
    const { type, url, metadata } = req.body || {};
    if (!userId) return res.status(401).json({ message: 'Unauthorized' });
    if (!['audio', 'video', 'image'].includes(type || '')) {
      return res.status(400).json({ message: 'type must be audio|video|image' });
    }

    let finalUrl = url;
    if (!finalUrl && req.file?.buffer) {
      const uploaded = await mediaService.uploadToCloud(req.file.buffer, { type });
      finalUrl = uploaded.url;
    }
    if (!finalUrl) return res.status(400).json({ message: 'Provide file or url' });

    const doc = await Media.create({ user: userId, type, url: finalUrl, metadata: metadata || {} });
    res.status(201).json({ media: doc });
  } catch (err) { next(err); }
};

