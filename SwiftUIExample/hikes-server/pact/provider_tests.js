const { Verifier } = require('@pact-foundation/pact');
const packageJson = require('../package.json');
const { app } = require('../app.js')
const { hikeRepository } = require('../Repository/hike-repository.js')

var server = require('http').createServer(app);
server.listen(3000, () => {
  console.log("Hikes Service listening on http://localhost:3000")
})

let opts = {
    providerBaseUrl: 'http://localhost:3000',
    pactBrokerUrl: 'http://localhost:9080',
    provider: 'HikesService',
    publishVerificationResult: true,
    providerVersion: packageJson.version,
    stateHandlers: {
        [null]: () => {
            // This is the "default" state handler, when no state is given
        }
    }
};

new Verifier().verifyProvider(opts).then(function () {
    console.log("Pacts successfully verified!");
    server.close()
});
