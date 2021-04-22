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
          return res
            .status(500)
            .json({
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

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
