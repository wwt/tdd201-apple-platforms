const { Verifier } = require('@pact-foundation/pact');
const packageJson = require('../package.json');

let opts = {
    providerBaseUrl: 'http://localhost:3000',
    pactBrokerUrl: 'http://localhost:9080',
//    pactBrokerUsername: process.env.PACT_USERNAME,
//    pactBrokerPassword: process.env.PACT_PASSWORD,
    provider: 'UserService',
    publishVerificationResult: true,
    providerVersion: packageJson.version,
    providerStatesSetupUrl: 'http://localhost:3000/provider-state'
};

new Verifier().verifyProvider(opts).then(function () {
    console.log("Pacts successfully verified!");
});
