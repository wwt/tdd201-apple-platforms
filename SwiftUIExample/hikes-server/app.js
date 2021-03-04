const express = require('express');
const hikesRouter = require('./routes/hikes');

var app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use('/hikes', hikesRouter);

module.exports = {
    app
}
