var express = require('express');
var router = express.Router();
const { landmarkRepository } = require('../Repository/landmark-repository.js')

router.get('/', (req, res) => {
    res.send(landmarkRepository.fetchAll())
});

module.exports = router;
