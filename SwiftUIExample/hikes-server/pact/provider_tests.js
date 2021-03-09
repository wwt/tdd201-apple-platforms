const { Verifier } = require('@pact-foundation/pact');
const packageJson = require('../package.json');
const { app } = require('../app.js')
const { hikeRepository } = require('../Repository/hike-repository.js')
const { landmarkRepository } = require('../Repository/landmark-repository.js')

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
        },
        "A landmark that is NOT favorited with id 1": () => {
            landmarkRepository.clear()
            landmarkRepository.insert({
                "name": "Turtle Rock",
                "category": "Rivers",
                "city": "Twentynine Palms",
                "state": "California",
                "id": 1,
                "isFeatured": true,
                "isFavorite": false,
                "park": "Joshua Tree National Park",
                "coordinates": {
                    "longitude": -116.166868,
                    "latitude": 34.011286
                },
                "description": "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus, cras ante etiam sit conubia elit tempus accumsan libero, mattis per erat habitasse cubilia ligula penatibus curae. Sagittis lorem augue arcu blandit libero molestie non ullamcorper, finibus imperdiet iaculis ad quam per luctus neque, ligula curae mauris parturient diam auctor eleifend laoreet ridiculus, hendrerit adipiscing sociosqu pretium nec velit aliquam. Inceptos egestas maecenas imperdiet eget id donec nisl curae congue, massa tortor vivamus ridiculus integer porta ultrices venenatis aliquet, curabitur et posuere blandit magnis dictum auctor lacinia, eleifend dolor in ornare vulputate ipsum morbi felis. Faucibus cursus malesuada orci ultrices diam nisl taciti torquent, tempor eros suspendisse euismod condimentum dis velit mi tristique, a quis etiam dignissim dictum porttitor lobortis ad fermentum, sapien consectetur dui dolor purus elit pharetra. Interdum mattis sapien ac orci vestibulum vulputate laoreet proin hac, maecenas mollis ridiculus morbi praesent cubilia vitae ligula vel, sem semper volutpat curae mauris justo nisl luctus, non eros primis ultrices nascetur erat varius integer.",
                "imageName": "turtlerock"
            })
        }
    }
};

new Verifier().verifyProvider(opts).then(function () {
    console.log("Pacts successfully verified!");
    server.close()
});
