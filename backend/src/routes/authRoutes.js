const router = require('express').Router();
const { verifyOtp, sendOtp } = require('../controllers/authController');

router.post('/send-otp', sendOtp);
router.post('/verify-otp', verifyOtp);

module.exports = router;

