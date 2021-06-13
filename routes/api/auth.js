const express = require('express');
const router = express.Router();

const { registration, isExistSetUserInformation, setUserInformation  } = require("../../controller/auth");

router.route('/registration').post(registration);
router.route('/isExistSetUserInformation').post(isExistSetUserInformation);
router.route('/setUserInformation').post(setUserInformation);

module.exports = router;
