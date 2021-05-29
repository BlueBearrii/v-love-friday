const express = require("express");
const admin = require("firebase-admin");

const firestore = admin.firestore();

exports.createTripRoom = async (req, res) => {
  const { uid, tripName, budget, days, place } = req.body;
  const _trip = {
    uid: uid,
    tripName: tripName,
    budget: budget,
    balance: budget,
    days: days,
    place: place
  }

  try {
    const _createTripRoom = await firestore.collection("trips").add(_trip)

    const update = await _createTripRoom.update({ tripId: _createTripRoom.id })

    res.status(201).json({ code: "trip/created", message: update })
  } catch (error) {
    res.status(400).json(error)
  }

}