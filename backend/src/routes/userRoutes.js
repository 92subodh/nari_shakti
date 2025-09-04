const router = require('express').Router();
const auth = require('../middlewares/authMiddleware');
const { updateTrustedContacts, setSafeWord, shutdownAttempt, verifyShutdown } = require('../controllers/userController');

router.use(auth);
router.put('/contacts', updateTrustedContacts);
router.put('/safe-word', setSafeWord);
router.post('/shutdown/attempt', shutdownAttempt);
router.post('/shutdown/verify', verifyShutdown);

module.exports = router;

