const express = require("express");
const admin = require("firebase-admin");
const liked = require("../utils/like_dislike");
const upload_image_lanscape = require("../utils/upload_image-lanscape");

const firestore = admin.firestore();

exports.createHost = async (req, res) => {
    const { hostName, address, contact, coverUrl, uid, order, type, description, conditions } = req.body;
    const host = {
        hostName: hostName,
        address: address,
        contact: contact,
        coverUrl: coverUrl,
        order: order,
        uid: uid,
        type: type,
        likes: [],
        images: [],
        comments: [],
        description: description,
        conditions: conditions
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
                if (balance >= data.data().price.value) {
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

            if (keywords.length !== 0) {
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

exports.fetchAllHosting = async (req, res) => {
    const { type, uid, searchName } = req.body;

    console.log(req.body)

    let arr = [];

    try {

        var getAll = await firestore.collection("hosting").get().then((value) => {
            value.docs.forEach(element => {
                if (type == null && searchName == null) {
                    arr.push(element.data())
                } else if (type == null && searchName !== null) {
                    if (element.data().hostName.includes(searchName) || element.data().address.province.includes(searchName) || element.data().address.city.includes(searchName)) {
                        arr.push(element.data())
                    }
                } else if (type !== null && (searchName == null ||searchName == '')) {
                    if (element.data().type == type) {
                        arr.push(element.data())
                    }
                } else if(type !== null && searchName !== null){
                    if (element.data().type == type || element.data().hostName.includes(searchName) || element.data().address.province.includes(searchName) || element.data().address.city.includes(searchName)) {
                        arr.push(element.data())
                    }
                }
            })
        })

        console.log(arr)

        res.status(200).json({ message: arr.length == 0 ? null : arr })

    } catch (error) {
        res.status(400).json(error)
    }
}

exports.likeHost = async (req, res) => {
    const { hostId, uid } = req.body;
    const _collection = "hosting"
    try {

        const like = await liked("hosting", hostId, uid);

        res.status(201).json({ code: "host/liked", message: like })

    } catch (error) {
        res.status(400).json(error)
    }
}

exports.uploadPhoto = async (req, res) => {
    const { uid, name, path } = req.body;
    const file = req.file;

    console.log(file)

    try {

        const upload = await upload_image_lanscape(file, path, `${Math.floor(100000 + Math.random() * 900000)}`)

        console.log(upload.message);

        res.status(201).json(upload.message)

    } catch (error) {
        res.status(400).json(error)
    }
}

exports.uploadPhotos = async (req, res) => {
    const { uid, path } = req.body;
    const files = req.files;

    console.log(files)
    let arr = [];

    try {

        for (var index in files) {
            const _upload = await upload_image_lanscape(files[index], path, `${Math.floor(100000 + Math.random() * 900000)}`)
            console.log(_upload);
            arr.push(_upload.message);

        }

        //const upload =  await upload_image_lanscape(file, path, name)

        console.log(arr);

        res.status(201).json(arr)

    } catch (error) {
        res.status(400).json(error)
    }
}



