const express = require("express");
const admin = require("firebase-admin");

const auth = admin.auth();
const firestore = admin.firestore();

exports.createHost = async (req, res) => {
    const { lifstyle, hostname, address, contact, uid } = req.body;

    try {

        res.json({ code: "auth/user-found", message: "hello" });

    } catch (error) {
        res.json(error)
    }
}


