const express = require('express');
const router = express.Router();
const multer = require("../../utils/multerUtil");

const {createTrip} = require("../../controller/trip");

router.route('/createTrip').post(multer.single("file"), createTrip);

module.exports = router;