const express = require('express');
const router = express.Router();
const { verifiedUid } = require('../../middleware/verifiedUid');


const { createHost, likeHost } = require("../../controller/host");

router.route('/createHost').post(verifiedUid, createHost);
router.route('/likeHost').post(verifiedUid, likeHost);

module.exports = router;
