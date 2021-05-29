const express = require('express');
const router = express.Router();
const multer = require("../../utils/multerUtil");
const { verifiedUid } = require('../../middleware/verifiedUid');


const { createTripRoom } = require("../../controller/trip");

router.route('/createTripRoom').post(verifiedUid, createTripRoom);

module.exports = router;
