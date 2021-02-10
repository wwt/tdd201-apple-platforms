var express = require('express');
var router = express.Router();
const { userRepository } = require('../Repository/user-repository.js')

router.get('/:id', function(req, res, next) {
    const response = userRepository.getById(req.params.id)
    if (response) {
        res.send(response)
    } else {
        res.status(404).send()
    }
});

module.exports = router;
