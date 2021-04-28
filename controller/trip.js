const express = require("express");
const fs = require("fs");
const admin = require("firebase-admin");
const { url } = require("inspector");
const { format } = require("path");

const db = admin.firestore();
const storage = admin.storage().bucket();

exports.createTrip = async (req, res) => {
  const { file } = req;
  const {title, budget, tripId, uid} = req.body
  const filename = `${tripId}_${uid}`
  const url = `https://firebasestorage.googleapis.com/v0/b/${storage.name}/o/${filename}?alt=media`;

  
  try {
    const _file = await storage.file(filename);

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
      const addTrip = await db.collection("file").add({title: title,budget: budget, path: url});
      res.status(200).json(addTrip);
    });
    blobStream.end(file.buffer);
  } catch (error) {
    res.status(500).json(error);
  }

  // console.log(req.file);
  // try {
  //      const addTrip = await db.collection("file").add(req.body);
  //      res.status(200).json(addTrip);
  //  } catch (error) {
  //      res.status(500).json(error);
  //  }
};
