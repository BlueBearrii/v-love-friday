const express = require("express");
const fs = require("fs");
const admin = require("firebase-admin");
const { url } = require("inspector");
const { format } = require("path");

const db = admin.firestore();
const storage = admin.storage().bucket();

exports.createTrip = async (req, res) => {
  const { file } = req;
  const { title, budget, tripId, uid, status } = req.body;
  const filename = `${tripId}_${uid}`;
  const url = `https://firebasestorage.googleapis.com/v0/b/${storage.name}/o/coverImages%2F${filename}?alt=media`;

  try {
    const _file = await storage.file(`coverImages/${filename}`);

    const blobStream = await _file.createWriteStream({
      metadata: {
        contentType: file.mimetype,
        firebaseStorageDownloadTokens: null,
      },
    });

    blobStream.on("error", (error) => {
      console.log(error);
    });

    blobStream.on("finish", async () => {
      console.log("Upload Done");
      const addTrip = await db.collection("trips").add({
        title: title,
        budget: budget,
        path: url,
        tripId : tripId,
        uid: uid,
        status: status,
      });
      res.status(200).json(addTrip);
    });
    blobStream.end(file.buffer);
  } catch (error) {
    res.status(500).json(error);
  }
};

exports.getTrips = async (req, res) => {
  const { uid } = req.body;
  var array = [];

  try {
    const fetchTrips = await db.collection("trips").get();

    fetchTrips.docs.forEach((doc) => {
      if (doc.data().uid == uid) array.push(doc.data());
      else console.log("not done");
    });

    res.status(200).json(array);
  } catch (error) {
    res.status(500).json(error);
  }
};

exports.deleteTrip = async (req, res) => {
  const { uid, tripId } = req.body;
  const filename = `${tripId}_${uid}`;
  try {
    const ref = await db.collection("trips");
    const fetchTrips = await ref.get();
    fetchTrips.docs.forEach(async (doc) => {
      if (doc.data().uid == uid && doc.data().tripId == tripId) {
        ref.doc(doc.id).delete();
        await storage.file(`coverImages/${tripId}_${uid}`).delete()

      } else console.log("not done");
    });

    res.status(200).json({ status: "done" });
  } catch (error) {
    res.status(500).json(error);
  }
};
