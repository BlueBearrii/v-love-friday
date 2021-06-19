const express = require("express");
const admin = require("firebase-admin");
const upload_image_square = require("../utils/upload_image-square");

const auth = admin.auth();
const firestore = admin.firestore();

exports.userInfo = async (req, res) => {
    const { uid } = req.body;

    try {

        const user = await firestore.collection("users").doc(uid).get()

        console.log(user)

        res.status(200).json({code: "auth/user", message: user.data() })

    } catch (error) {
        res.status(400).json(error)
    }
}

exports.registration = async (req, res) => {
    const { email, uid, phone, displayName, user_image_path } = req.body;

    console.log(req.body)

    try {

        const user = await firestore.collection("users").doc(uid).set({
            email: email,
            uid: uid,
            phone: phone,
            displayName: displayName,
            user_image_path: user_image_path,
            wallet: 0,
        })

        res.status(201).json({code: "auth/created", message: user })

    } catch (error) {
        res.status(400).json(error)
    }
}

exports.uploadProfile = async (req, res) => {
    const { uid } = req.body;
    const file = req.file;

    console.log(file)

    try {

        const upload =  await upload_image_square(req.file, "user-profile", `${uid}`)

        res.status(201).json(upload)

    } catch (error) {
        res.status(400).json(error)
    }
}