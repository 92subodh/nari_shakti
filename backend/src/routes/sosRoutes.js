const router = require('express').Router();
const auth = require('../middlewares/authMiddleware');
const { startSOS, endSOS } = require('../controllers/sosController');

router.use(auth);
router.post('/start', startSOS);
router.post('/end', endSOS);

module.exports = router;

