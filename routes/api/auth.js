const express = require('express');
const router = express.Router();

const { registration, setUserInformation  } = require("../../controller/auth");

router.route('/registration').post(registration);
router.route('/setUserInformation').post(setUserInformation);

module.exports = router;
