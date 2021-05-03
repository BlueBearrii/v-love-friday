const express = require('express');
const router = express.Router();
const multer = require("../../utils/multerUtil");

const {createTrip, getTrips, deleteTrip} = require("../../controller/trip");

router.route('/createTrip').post(multer.single("file"), createTrip);
router.route('/getTrips').post(getTrips);
router.route('/deleteTrip').delete(deleteTrip);
module.exports = router;
