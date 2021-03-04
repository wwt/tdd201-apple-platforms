const express = require('express');
const hikesRouter = require('./routes/hikes');
const landmarksRouter = require('./routes/landmarks');

var app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use('/hikes', hikesRouter);
app.use('/landmarks', landmarksRouter);

module.exports = {
    app
}
