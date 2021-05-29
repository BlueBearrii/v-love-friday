const express = require("express");
const admin = require("firebase-admin");
const liked = require("../utils/liked");

const firestore = admin.firestore();

exports.createHost = async (req, res) => {
    const { lifstyle, hostname, address, contact, uid } = req.body;
    const host = {
        lifstyle: lifstyle,
        hostname: hostname,
        address: address,
        contact: contact,
        uid: uid,
        likes: [],
        images: []
    }

    try {

        const createHost = await firestore.collection("hosting").add(host);

        const update = await createHost.update({ hostid: createHost.id })

        res.status(201).json({ code: "host/created", message: update })

    } catch (error) {
        res.status(400).json(error)
    }
}

exports.likeHost = async (req, res) => {
    const { id, uid } = req.body;
    const _collection = "hosting"
    try {

        const like = await liked(_collection, id, uid);

        res.status(201).json({ code: "host/liked", message: like })

    } catch (error) {
        res.status(400).json(error)
    }
}


