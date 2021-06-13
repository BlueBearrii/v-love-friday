const express = require("express");
const admin = require("firebase-admin");
const liked = require("../utils/liked");

const firestore = admin.firestore();

exports.createHost = async (req, res) => {
    const { lifstyle, hostname, address, contact, uid, keywords } = req.body;
    const host = {
        lifstyle: lifstyle,
        hostname: hostname,
        address: address,
        contact: contact,
        keywords: keywords,
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

exports.fetchHosting = async (req, res) => {
    const { uid, type, lifstyle, keywords } = req.body;
    let arr = []
    let exist = [];

    console.log(req.body)

    try {
        if (type == null && lifstyle.length == 0 && keywords.length == 0) {
            const _fetchingHostAll = await firestore.collection("hosting").get()

            const mapHostingAll = await _fetchingHostAll.docs.map(data => {
                arr.push(data.data());
            })

        } else {
            console.log("Do this!")
            console.log(exist)
            

            if (type !== null) {
                console.log("Do this!!")
                const _fetchingHostType = await firestore.collection("hosting").where("type", "==", type).get()
                const mapHostingType = await _fetchingHostType.docs.map(data => {
                    if (exist.includes(data.id) == false) {
                        arr.push(data.data());
                        exist.push(data.id);
                    }
                })
            }

            if (lifstyle.length !== 0) {
                console.log("Do this!!!")
                const _fetchingHostLifestyle = await firestore.collection("hosting").where("lifstyle", "array-contains-any", lifstyle).get()
                const mapHostingLifestyle = await _fetchingHostLifestyle.docs.map(data => {
                    if (!exist.includes(data.id)) {
                        arr.push(data.data());
                        exist.push(data.id);
                    }
                })
            }

            if (keywords.length !== 0 ) {
                console.log("Do this!!!!")
                const _fetchingHostKeywords = await firestore.collection("hosting").where("keywords", "array-contains-any", keywords).get()
                const mapHostingKeywords = await _fetchingHostKeywords.docs.map(data => {
                    if (!exist.includes(data.id)) {
                        arr.push(data.data());
                        exist.push(data.id);

                    }
                })

            }
        }

        console.log(arr)

        res.status(200).json({ message: arr })

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


