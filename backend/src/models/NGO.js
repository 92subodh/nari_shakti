const mongoose = require('mongoose');

const ngoSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    contact: { phone: String, email: String },
    area: String,
  },
  { timestamps: true }
);

module.exports = mongoose.model('NGO', ngoSchema);

