const express = require('express');
const router = express.Router();
const { verifiedUid } = require('../../middleware/verifiedUid');


const { createHost, fetchHosting, likeHost } = require("../../controller/host");

router.route('/createHost').post(verifiedUid, createHost);
router.route('/fetchHosting').post(verifiedUid, fetchHosting);
router.route('/likeHost').post(verifiedUid, likeHost);

module.exports = router;
