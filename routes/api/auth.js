const express = require('express');
const router = express.Router();
const multer = require("../../utils/multerUtil");
const { verifiedUid } = require('../../middleware/verifiedUid');

const { registration, uploadProfile, userInfo } = require("../../controller/auth");

router.route('/userInfo').post(userInfo);
router.route('/registration').post(registration);
router.route('/uploadProfile').post(multer.single('file'), uploadProfile);


module.exports = router;
