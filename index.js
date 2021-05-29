const express = require("express");
const app = express();
const firebaseInitialize  = require("./utils/firebaseInitializeApp");

firebaseInitialize();

app.use(express.json());
app.use(express.urlencoded());

app.use('/api/trip', require('./routes/api/trip'));
app.use('/api/auth', require('./routes/api/auth'));


const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});




