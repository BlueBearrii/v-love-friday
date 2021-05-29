const express = require("express");
const admin = require("firebase-admin");

const auth = admin.auth();
const firestore = admin.firestore();

exports.registration = async (req, res) => {
    const { email } = req.body;

    try {
        const isExist = await auth.getUserByEmail(email);
        res.json({ code: "auth/user-is-existing", message: isExist });

    } catch (error) {
        res.json(error)
    }
}

exports.setUserInformation = async (req, res) => {
    const { email, uid, phone, firstname, lastname } = req.body;

    try {
        const user = await firestore.collection("users").doc(uid).set({
            email : email,
            phone : phone,
            firstname : firstname,
            lastname : lastname,
            uid : uid
        })

        res.json(user)
    } catch (error) {
        res.json(error)
    }
}

