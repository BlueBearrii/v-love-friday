const express = require('express');
const router = express.Router();
const multer = require("../../utils/multerUtil");
const { verifiedUid } = require('../../middleware/verifiedUid');


const { createTripRoom, updateBalance, fetchBooked } = require("../../controller/trip");

router.route('/createTripRoom').post(verifiedUid, createTripRoom);
router.route('/fetchBooked').post(verifiedUid, fetchBooked);
router.route('/updateBalance').post(verifiedUid, updateBalance);

module.exports = router;
