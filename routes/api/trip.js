const express = require('express');
const router = express.Router();
const multer = require("../../utils/multerUtil");

const { testUpload } = require("../../controller/trip");

router.route('/testUpload').post(multer.single("file"), testUpload);

module.exports = router;
