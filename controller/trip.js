const express = require("express");
const admin = require("firebase-admin");
const like_click = require("../utils/like_dislike");
const posting = require("../utils/posting");

const firestore = admin.firestore();

exports.createTripRoom = async (req, res) => {
    const { uid, tripName, budget, days, destination, user_image_path } = req.body;
    const initialCover = "https://firebasestorage.googleapis.com/v0/b/vr-love-friday.appspot.com/o/initial-cover-book%2Fdino-reichmuth-A5rCN8626Ck-unsplash-2.jpg?alt=media&token=3d6e9118-1aca-4286-9f29-9c8590823cff"

    try {
        const _createTripRoom = await firestore.collection("trips").add({
            uid: uid,
            tripName: tripName,
            budget: budget,
            balance: budget,
            days: days,
            destination: destination,
            coverUrl: initialCover,
            user_image_path: user_image_path,
            posts: [],
            likes: [],
            comments: [],
            createdAt: new Date().toISOString(),
            public: false
        })

        const update = await _createTripRoom.update({ tripId: _createTripRoom.id })

        res.status(201).json({ code: "trip/created", message: update })
    } catch (error) {
        res.status(400).json(error)
    }

}

exports.fetchTrips = async (req, res) => {
    const { uid } = req.body;
    let arr = [];

    try {
        const tripsCollection = await firestore.collection("trips").orderBy("createdAt", "desc").get()

        const mapTrips = await tripsCollection.forEach(responseData => {

            if (responseData.data().uid === uid) {
                arr.push(responseData.data());
            }

            return arr;
        })

        res.status(200).json({ message: arr })
    } catch (error) {
        res.status(400).json(error)
    }

}

exports.fetchTrip = async (req, res) => {
    const { uid } = req.body;
    let arr = [];

    try {
        const tripsCollection = await firestore.collection("trips").where("uid", "==", uid).get()

        const mapTrips = await tripsCollection.forEach(responseData => {
            arr.push(responseData.data());

            return arr;
        })

        res.status(200).json({ message: arr })
    } catch (error) {
        res.status(400).json(error)
    }

}

exports.fetchTripPublic = async (req, res) => {
    const { uid } = req.body;
    let arr = [];

    try {
        const tripsCollection = await firestore.collection("trips").where("public", "==", true).get()

        const mapTrips = await tripsCollection.forEach(responseData => {
            arr.push(responseData.data());

            return arr;
        })

        res.status(200).json({ message: arr })
    } catch (error) {
        res.status(400).json(error)
    }

}



exports.fetchBooked = async (req, res) => {
    const { uid, tripId } = req.body;
    const _trip = {
        uid: uid,
        tripId: tripId,
    }

    let arr = [];

    try {
        const fetching = await firestore.collection("booking").orderBy("bookingDate").get()

        const mapBooked = await fetching.forEach(responseData => {
            if (responseData.data().uid == uid && responseData.data().tripId == tripId) {
                arr.push(responseData.data());
            }

            return arr;
        })

        res.status(200).json({ code: "trip/fetch_booked", message: arr })
    } catch (error) {
        res.status(400).json(error)
    }

}

exports.loadBalance = async (req, res) => {
    const { uid, tripId } = req.body;

    try {
        const ref = await firestore.collection("trips").doc(tripId).get();

        res.json({ message: ref.data() });
    } catch (error) {
        res.status(403).json(error)
    }
}

exports.updateBalance = async (req, res, next) => {
    const { uid, tripId, pay } = req.body;

    try {
        const ref = await firestore.collection("trips").doc(tripId)

        const update = await ref.update({ balance: admin.firestore.FieldValue.increment(pay * (-1)) })

        next();
    } catch (error) {
        res.status(403).json(error)
    }
}

exports.bookNow = async (req, res) => {
    const { uid, tripId, hostId, coverUrl, hostName, pay, bookingDate } = req.body;

    const booking = {
        uid: uid,
        tripId: tripId,
        hostId: hostId,
        hostName: hostName,
        status: false,
        bookingDate: bookingDate,
        pay: pay,
        coverUrl: coverUrl,
        createdAt: new Date().toISOString()
    }

    try {
        const _createBooking = await firestore.collection("booking").add(booking)

        const update = await _createBooking.update({ bookingId: _createBooking.id })

        res.status(201).json({ code: "booking/created", message: update })
    } catch (error) {
        res.status(400).json(error)
    }

}


exports.post = async (req, res) => {
    const { uid, tripId, comments, username, user_image_path, createdAt } = req.body;
    const file = req.file;

    try {

        const upload_photo = await upload_image_square(file, "user-profile", `${uid}`)

        const upload_post = await posting("trips", tripId, uid, user_image_path, username, comments, createdAt, upload_photo)

        res.status(201).json({ message: upload_post })

    } catch (error) {
        res.status(400).json(error)
    }
}


exports.likeTrip = async (req, res) => {
    const { tripId, uid } = req.body;
    try {

        const like = await like_click("trips", tripId, uid);

        res.status(201).json({ message: like })

    } catch (error) {
        res.status(400).json(error)
    }
}