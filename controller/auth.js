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

exports.isExistSetUserInformation = async (req, res) => {
    const { email } = req.body;
    let _isExist = false;

    try {
        const isExist = await firestore.collection("users").get();
        const find = await isExist.forEach(value => {
            if(value.data().email == email) _isExist = true;
        })
        console.log(_isExist);
        res.json({ code: "auth/checker", message: _isExist });

    } catch (error) {
        res.json(error)
    }
}

exports.setUserInformation = async (req, res) => {
    const { email, uid, phone, firstname, lastname, lifestyles } = req.body;

    try {
        const user = await firestore.collection("users").doc(uid).set({
            email : email,
            phone : phone,
            firstname : firstname,
            lastname : lastname,
            uid : uid, 
            lifestyles : lifestyles
        })

        res.status(201).json({ code: "auth/created", message: user })
    } catch (error) {
        res.status(400).json(error)
    }
}

