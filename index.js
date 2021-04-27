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

app.get("/api/get-update", (req, res) => {
  db.collection("trips").onSnapshot((querySnapshot) => {
    var trips = [];
    querySnapshot.docs.forEach((change) => {
      trips.push(change.id);
    });
    console.log(trips);
    return res.status(200).json({trips});
  });
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
