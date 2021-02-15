var express = require('express');
var router = express.Router();
const { userRepository } = require('../Repository/user-repository.js')
const jwt = require('jsonwebtoken');
const expressJwt = require('express-jwt')

router.get('/:id', expressJwt({ secret: 'supersecret', algorithms: ['HS256'] }),
           function(req, res, next) {
    const response = userRepository.getById(req.params.id)
    if (response) {
        res.send(response)
    } else {
        res.status(404).send()
    }
});

router.post('/login', function(req, res, next) {
    var accessToken = jwt.sign({ exp: Math.floor(Date.now() / 1000) + 30 }, 'supersecret')
    var refreshToken = jwt.sign({ exp: Math.floor(Date.now() / 1000) + (60 * 60) }, 'supersecret')
    res.send({ accessToken, refreshToken })
});

router.post('/refresh', function(req, res, next) {
    var accessToken = req.body.accessToken
    var refreshToken = req.body.refreshToken
    if(!accessToken || !refreshToken) {
        res.status(403).send()
    }
    try {
        jwt.verify(refreshToken, 'supersecret')
    } catch {
        res.status(401).send()
    }
    var newAccessToken = jwt.sign({ exp: Math.floor(Date.now() / 1000) + 30 }, 'supersecret')

    res.send({ newAccessToken })
});

module.exports = router;
