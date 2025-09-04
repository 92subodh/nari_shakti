const mongoose = require('mongoose');

const locationSchema = new mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    coordinates: {
      type: { type: String, enum: ['Point'], default: 'Point' },
      coordinates: { type: [Number], index: '2dsphere' },
    },
    isDangerZone: { type: Boolean, default: false },
    predictedRiskScore: { type: Number, default: 0 },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Location', locationSchema);

