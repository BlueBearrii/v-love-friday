const express = require('express');
const router = express.Router();
const multer = require("../../utils/multerUtil");
const { verifiedUid } = require('../../middleware/verifiedUid');


const { createHost, fetchHosting, fetchAllHosting, likeHost, uploadPhoto, uploadPhotos } = require("../../controller/host");

router.route('/createHost').post(verifiedUid, createHost);
router.route('/fetchHosting').post(verifiedUid, fetchHosting);
router.route('/fetchAllHosting').post(verifiedUid, fetchAllHosting);
router.route('/likeHost').post(verifiedUid, likeHost);
router.route('/uploadPhoto').post(multer.single('file'), uploadPhoto);
router.route('/uploadPhotos').post(multer.array('files'), uploadPhotos);


module.exports = router;
