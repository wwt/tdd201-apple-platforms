var express = require('express');
var router = express.Router();
const { hikeRepository } = require('../Repository/hike-repository.js')

router.get('/', (req, res) => {
    res.send(hikeRepository.fetchAll())
});

module.exports = router;
