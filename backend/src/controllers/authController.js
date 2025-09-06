const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const { JWT_SECRET,JWT_REFRESH_SECRET } = require('../config/env');

exports.sendOtp = async (req, res, next) => {
  try {
    const { phone } = req.body;
    let user = await User.findOne({ phone });

    if (!user) {
      // auto-register with phone only
      try {
        user = await User.create({ phone });
      } catch (error) {
        console.log(error);
      }
    }

    // Generate 4-digit OTP
    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    const expiresAt = new Date(Date.now() + 5 * 60 * 1000); // 5 mins

    user.otp = { code: otp, expiresAt };
    await user.save();

    // TODO: integrate SMS provider (Twilio, AWS SNS, etc.)
    console.log(`OTP for ${phone}: ${otp}`);

    res.json({ message: 'OTP sent successfully' });
  } catch (err) {
    next(err);
  }
};


exports.verifyOtp = async (req, res, next) => {
  try {
    const { phone, otp } = req.body;
    const user = await User.findOne({ phone });

    if (!user || !user.otp) {
      return res.status(400).json({ message: 'OTP not found. Please request again.' });
    }

    if (user.otp.expiresAt < Date.now()) {
      return res.status(400).json({ message: 'OTP expired' });
    }

    if (user.otp.code !== otp) {
      return res.status(400).json({ message: 'Invalid OTP' });
    }

    // Clear OTP after successful login
    user.otp = undefined;
    await user.save();

    // Access token (short-lived, e.g., 15 minutes)
    const token = jwt.sign(
      { id: user._id, phone: user.phone },
      JWT_SECRET,
      { expiresIn: '15m' }
    );

    // Refresh token (long-lived, e.g., 7 days)
    const refreshToken = jwt.sign(
      { id: user._id },
      JWT_REFRESH_SECRET,
      { expiresIn: '7d' }
    );

    console.log(`User ${phone} logged in`);

    res.json({
      token,
      refreshToken,
      user: {
        id: user._id,
        name: user.name,
        phone: user.phone,
      },
    });
  } catch (err) {
    next(err);
  }
};
