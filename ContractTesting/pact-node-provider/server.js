const express = require('express');
const path = require('path');
const Repository = require("./Repository/repository.js")

var usersRouter = require('./routes/users');

var server = express();

server.use(express.json());
server.use(express.urlencoded({ extended: false }));
server.use(express.static(path.join(__dirname, 'public')));

const userRepository = new Repository()

//server.use('/users', usersRouter);

server.get('/users/:id', function(req, res, next) {
    const response = userRepository.getById(req.params.id)
    if (response) {
        res.send(response)
    } else {
        res.status(404).send()
    }
});

module.exports = {
    server,
    userRepository,
}
