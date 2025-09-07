const mongoose = require('mongoose');

const userSchema = new mongoose.Schema(
  {
    name: { type: String }, // optional, add later in onboarding
    phone: { type: String, required: true, unique: true }, // 🔑 phone is unique identifier now
    // passwordHash: { type: String }, // only if you keep password flow
    // email: { type: String }, // <-- remove unique & required
    kyc: {
      aadharNumber: String,
      verified: { type: Boolean, default: false },
    },
    trustedContacts: [{ name: String, phone: String }],
    safeWord: { type: String },
    antiShutdownPassword: { type: String },
  },
  { timestamps: true }
);

module.exports = mongoose.model('User', userSchema);
