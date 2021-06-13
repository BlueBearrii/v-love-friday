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
    const { uid, type, lifstyle, keywords, balance } = req.body;
    let arr = []
    let exist = [];

    console.log(req.body)

    try {
        if (type == null && lifstyle.length == 0 && keywords.length == 0) {
            const _fetchingHostAll = await firestore.collection("hosting").get()

            const mapHostingAll = await _fetchingHostAll.docs.map(data => {
                if(balance >= data.data().price.value){
                    arr.push(data.data());
                }
                
            })

        } else {

            if (type !== null) {
                const _fetchingHostType = await firestore.collection("hosting").where("type", "==", type).get()
                const mapHostingType = await _fetchingHostType.docs.map(data => {
                    if (exist.includes(data.id) == false && balance >= data.data().price.value) {
                        arr.push(data.data());
                        exist.push(data.id);
                    }
                })
            }

            if (lifstyle.length !== 0) {
                const _fetchingHostLifestyle = await firestore.collection("hosting").where("lifstyle", "array-contains-any", lifstyle).get()
                const mapHostingLifestyle = await _fetchingHostLifestyle.docs.map(data => {
                    if (!exist.includes(data.id) && balance >= data.data().price.value) {
                        arr.push(data.data());
                        exist.push(data.id);
                    }
                })
            }

            if (keywords.length !== 0 ) {
                const _fetchingHostKeywords = await firestore.collection("hosting").where("keywords", "array-contains", keywords).get()
                const mapHostingKeywords = await _fetchingHostKeywords.docs.map(data => {
                    if (!exist.includes(data.id) && balance >= data.data().price.value) {
                        arr.push(data.data());
                        exist.push(data.id);

                    }
                })

            }
        }

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


exports.gotLikeHost = async (req, res) => {
    const { id, uid } = req.body;
    var resp;
    try {

        const _fetchingHostAll = await firestore.collection("hosting").where("hostid", "==", id).get()


        const isCheck = await _fetchingHostAll.docs.map(data => {
            if(data.id == id){
                resp = data.data().likes.includes(uid);
            }
        })

        console.log(resp)

        res.status(201).json({ code: "host/liked", message: resp })

    } catch (error) {
        res.status(400).json(error)
    }
}


