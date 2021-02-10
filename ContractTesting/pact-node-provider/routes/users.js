var express = require('express');
var router = express.Router();
const { userRepository } = require('../Repository/user-repository.js')

router.get('/:id', function(req, res, next) {
    const response = userRepository.fetchAll() //userRepository.getById(req.params.id)
    if (response) {
        res.end(JSON.stringify(response))
    } else {
        res.writeHead(404)
        res.end()
    }
});

module.exports = router;
