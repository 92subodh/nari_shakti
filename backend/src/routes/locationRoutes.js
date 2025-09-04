const router = require('express').Router();
const auth = require('../middlewares/authMiddleware');
const { liveTracking } = require('../controllers/locationController');

router.use(auth);
router.get('/live', liveTracking);

module.exports = router;

