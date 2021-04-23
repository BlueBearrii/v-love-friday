const express = require("express");

const app = express();
app.use(express.json());
app.use(express.urlencoded());

const admin = require("firebase-admin");
var serviceAccount = require("./config/serviceAccountKey.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});
const db = admin.firestore();

app.post("/api/create-trip", (req, res) => {
  const body = {
    uid: req.body.uid,
    tripId: null,
    name: req.body.name,
    budget: req.body.budget,
    date: req.body.date,
    rating: null,
    wallpaper: req.body.wallpaper,
    storyTelling: null,
  };
  console.log(body);

  const docRef = db.collection("trips").add(body);
  docRef
    .then((serverResponse) => {
      serverResponse
        .update({ tripId: serverResponse.id })
        .then((updateResponse) => {
          return res.status(201).json({
            message: "Create new trip successful",
            serverResponse,
            updateResponse,
          });
        })
        .catch((updateErr) => {
          return res.status(500).json({
            message: "Something wrong can not update trip id",
            updateErr,
          });
        });
    })
    .catch((err) => {
      return res
        .status(500)
        .json({ message: "Something wrong can not create new trip", err });
    });
});

app.post("/api/booking", (req, res) => {
  const body = {
    tripId: req.body.tripId,
    uid: req.body.uid,
    date: req.body.date,
    time: req.body.time,
    placeId: req.body.placeId,
    type: req.body.type,
    status: "pending",
  };

  console.log(body);

  const docRef = db.collection("bookings").add(body);
  docRef
    .then((serverResponse) => {
      return res.status(201).json({
        message: "Booking successfull",
        serverResponse,
      });
    })
    .catch((err) => {
      return res
        .status(500)
        .json({ message: "Something wrong, booking not success", err });
    });
});

app.post("/api/hosting/register", (req, res) => {
  const body = {
    uid: req.body.uid,
    placeId: null,
    title: req.body.title,
    location: req.body.location,
    type: req.body.type,
    rule: req.body.rule,
    pricing: req.body.pricing,
    review: null,
    rate : null,
  };
  console.log(body);

  const docRef = db.collection("hosting").add(body);
  docRef
    .then((serverResponse) => {
      serverResponse
        .update({ placeId: serverResponse.id })
        .then((updateResponse) => {
          return res.status(201).json({
            message: "Hosting successfull",
            serverResponse,
            updateResponse,
          });
        })
        .catch((updateErr) => {
          return res.status(500).json({
            message: "Something wrong can not update host id",
            updateErr,
          });
        });
    })
    .catch((err) => {
      return res
        .status(500)
        .json({ message: "Something wrong, hosting not success", err });
    });
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
