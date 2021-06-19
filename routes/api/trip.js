const express = require('express');
const router = express.Router();
const multer = require("../../utils/multerUtil");
const { verifiedUid } = require('../../middleware/verifiedUid');


const { createTripRoom, fetchTrips, fetchTrip, fetchTripPublic, loadBalance,  updateBalance, bookNow, fetchBooked, post, likeTrip } = require("../../controller/trip");

router.route('/createTripRoom').post(verifiedUid, createTripRoom);
router.route('/fetchTrips').post(verifiedUid, fetchTrips);
router.route('/fetchTrip').post(verifiedUid, fetchTrip);
router.route('/loadBalance').post(verifiedUid, loadBalance);
router.route('/fetchBooked').post(verifiedUid, fetchBooked);
router.route('/bookNow').post(verifiedUid, updateBalance, bookNow);
router.route('/post').post(multer.single('file'),verifiedUid, post);
router.route('/fetchTripPublic').post(verifiedUid, fetchTripPublic);
router.route('/likeTrip').post(verifiedUid, likeTrip);

module.exports = router;
