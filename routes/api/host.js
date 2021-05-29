const express = require('express');
const router = express.Router();
const { verifiedUid } = require('../../middleware/verifiedUid');


const { createHost } = require("../../controller/host");

router.route('/createHost').post(verifiedUid, createHost);

module.exports = router;
