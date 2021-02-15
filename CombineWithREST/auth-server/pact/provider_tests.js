const { Verifier } = require('@pact-foundation/pact');
const packageJson = require('../package.json');
const { app } = require('../app.js')
const { userRepository } = require('../Repository/user-repository.js')

var server = require('http').createServer(app);
server.listen(3000, () => {
  console.log("User Service listening on http://localhost:3000")
})

let opts = {
    providerBaseUrl: 'http://localhost:3000',
    pactBrokerUrl: 'http://localhost:9080',
    provider: 'UserService',
    publishVerificationResult: true,
    providerVersion: packageJson.version,
    stateHandlers: {
        [null]: () => {
            // This is the "default" state handler, when no state is given
        },
        "A user with id 1 exists": () => {
            userRepository.clear()
            userRepository.insert({
                id: 1,
                name: "Bob",
                age: 22,
                email: "BobbyTheToddster@fake.com"
            })
            return Promise.resolve(`User with ID 1 Created.`)
        }
    }
};

new Verifier().verifyProvider(opts).then(function () {
    console.log("Pacts successfully verified!");
    server.close()
});
