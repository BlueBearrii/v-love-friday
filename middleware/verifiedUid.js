const express = require("express")
const admin = require("firebase-admin");

const auth = admin.auth();

exports.verifiedUid = async (req, res, next) => {
    const { uid } = req.body

    try {
        const verified = await auth.getUser(uid);
        //res.json({ code: "auth/user-found", message: verified });
        next()

    } catch (error) {
        res.json(error)
    }
}
