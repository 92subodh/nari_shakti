const router = require('express').Router();
const { listNGOs, createReport } = require('../controllers/communityController');

router.get('/ngos', listNGOs);
router.post('/report', createReport);

module.exports = router;

