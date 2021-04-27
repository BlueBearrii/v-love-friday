const express = require("express");
const fs = require("fs");
const admin = require("firebase-admin");

const db = admin.firestore();
const storage = admin.storage().bucket();

exports.createTrip = async (req, res) => {
  //const { file } = req.body;

  console.log(req.file);
  // try {
  //     const addTrip = await db.collection("file").add(req.body);
  //     res.status(200).json(addTrip);
  // } catch (error) {
  //     res.status(500).json(error);
  // }
  try {
    const file = await storage.file(`${req.file.originalname}`);
    const blobStream = file.createWriteStream({
      metadata: {
        contentType: req.file.mimetype,
      },
    });
    blobStream.on("error", (error) => {
      console.log(error);
    });
    blobStream.on("finish", async () => {
      console.log("Upload Done");
      const url = `https://firebasestorage.googleapis.com/v0/b/${storage.name}/o/${req.file.originalname}?alt=media`;
      res.status(200).json({ url: url });
    });
    blobStream.end(req.file.buffer);


    // const file = await storage
    //   .file(req.file.originalname, {
    //     firebaseStorageDownloadTokens: null,
    //   })
    //   .save(req.file.buffer);

    // console.log(file);
    // const url = `https://firebasestorage.googleapis.com/v0/b/${storage.name}/o/${req.file.originalname}?alt=media`;
    // res.status(200).json({ url: url });
  } catch (error) {
    res.status(404).json(error);
  }
};
