const express = require('express');
const mongoose = require('mongoose');

const PORT = process.env.PORT | 3001;

const app = express();

const DB =
  'mongodb+srv://shreyas:testpassword12@cluster0.39vs8gt.mongodb.net/?retryWrites=true&w=majority';
mongoose
  .connect(DB)
  .then(() => {
    console.log('Success');
  })
  .catch((err) => {
    console.log(err);
  });

app.listen(PORT, '0.0.0.0', () => {
  console.log(`connected at ${PORT}`);
});
