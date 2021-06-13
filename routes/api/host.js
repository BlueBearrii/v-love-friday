const express = require('express');
const router = express.Router();
const { verifiedUid } = require('../../middleware/verifiedUid');


const { createHost, fetchHosting, likeHost, gotLikeHost } = require("../../controller/host");

router.route('/createHost').post(verifiedUid, createHost);
router.route('/fetchHosting').post(verifiedUid, fetchHosting);
router.route('/likeHost').post(verifiedUid, likeHost);
router.route('/gotLikeHost').post(verifiedUid, gotLikeHost);

module.exports = router;
