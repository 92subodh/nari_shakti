const jwt = require("jsonwebtoken");
const User = require("../models/User");
const {
  JWT_SECRET,
  JWT_REFRESH_SECRET,
} = require("../config/env");

const twilio = require("twilio");
const client = twilio(
  process.env.TWILIO_ACCOUNT_SID,
  process.env.TWILIO_AUTH_TOKEN
);

// ✅ Send OTP
exports.sendOtp = async (req, res, next) => {
  try {
    const { phone } = req.body;

    // auto-register user if not exists
    let user = await User.findOne({ phone });
    if (!user) {
      user = await User.create({ phone });
    }

    // Send OTP via Twilio Verify
    const verification = await client.verify.v2
      .services(process.env.TWILIO_VERIFY_SERVICE_SID)
      .verifications.create({ to: phone, channel: "sms" });

    res.json({ message: "OTP sent successfully", sid: verification.sid });
  } catch (err) {
    console.error(err);
    next(err);
  }
};

// ✅ Verify OTP
exports.verifyOtp = async (req, res, next) => {
  try {
    const { phone, otp } = req.body;

    const verificationCheck = await client.verify.v2
      .services(process.env.TWILIO_VERIFY_SERVICE_SID)
      .verificationChecks.create({ to: phone, code: otp });

    if (verificationCheck.status !== "approved") {
      return res.status(400).json({ message: "Invalid or expired OTP" });
    }

    // User exists for sure
    const user = await User.findOne({ phone });

    // Generate tokens
    const token = jwt.sign({ id: user._id, phone: user.phone }, JWT_SECRET, {
      expiresIn: "15m",
    });

    const refreshToken = jwt.sign({ id: user._id }, JWT_REFRESH_SECRET, {
      expiresIn: "7d",
    });

    res.json({
      message: "OTP verified successfully",
      token,
      refreshToken,
      user: {
        id: user._id,
        name: user.name,
        phone: user.phone,
      },
    });
  } catch (err) {
    console.error(err);
    next(err);
  }
};
