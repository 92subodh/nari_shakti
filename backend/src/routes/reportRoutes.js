const router = require('express').Router();
const { uploadEvidence } = require('../controllers/reportController');

router.post('/evidence', uploadEvidence);

module.exports = router;

