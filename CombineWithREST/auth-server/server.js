const { app } = require('./app.js')

var server = require('http').createServer(app);
server.listen(3000, () => {
  console.log("User Service listening on http://localhost:3000")
})
