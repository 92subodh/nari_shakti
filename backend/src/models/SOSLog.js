const mongoose = require('mongoose');

const sosLogSchema = new mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    status: { type: String, enum: ['started', 'active', 'ended'], default: 'started' },
    active: { type: Boolean, default: true },
    startedAt: { type: Date, default: Date.now },
    endedAt: { type: Date },
    shutdownAttempt: { type: Date },
    notes: String,
  },
  { timestamps: true }
);

module.exports = mongoose.model('SOSLog', sosLogSchema);

