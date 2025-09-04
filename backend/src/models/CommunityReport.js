const mongoose = require('mongoose');

const communityReportSchema = new mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    anonymous: { type: Boolean, default: false },
    description: String,
    location: { type: { type: String, enum: ['Point'], default: 'Point' }, coordinates: [Number] },
  },
  { timestamps: true }
);

module.exports = mongoose.model('CommunityReport', communityReportSchema);

