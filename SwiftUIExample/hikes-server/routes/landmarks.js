var express = require('express');
var router = express.Router();
const { landmarkRepository } = require('../Repository/landmark-repository.js')

router.get('/', (req, res) => {
    res.send(landmarkRepository.fetchAll())
});

router.put('/:id/favorite', (req, res) => {
    const response = landmarkRepository.getById(req.params.id)
    response.isFavorite = req.body.isFavorite
    if (response) {
        res.send(response)
    } else {
        res.status(404).send()
    }
});

module.exports = router;
