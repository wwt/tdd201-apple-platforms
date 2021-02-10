"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var request_1 = require("../common/request");
var MockService = /** @class */ (function () {
    /**
     * @param {string} consumer - the consumer name
     * @param {string} provider - the provider name
     * @param {number} port - the mock service port, defaults to 1234
     * @param {string} host - the mock service host, defaults to 127.0.0.1
     * @param {boolean} ssl - which protocol to use, defaults to false (HTTP)
     * @param {string} pactfileWriteMode - 'overwrite' | 'update' | 'merge', defaults to 'overwrite'
     */
    function MockService(
    // Deprecated as at https://github.com/pact-foundation/pact-js/issues/105
    consumer, provider, 
    // Valid
    port, host, ssl, pactfileWriteMode) {
        if (port === void 0) { port = 1234; }
        if (host === void 0) { host = "127.0.0.1"; }
        if (ssl === void 0) { ssl = false; }
        if (pactfileWriteMode === void 0) { pactfileWriteMode = "overwrite"; }
        this.consumer = consumer;
        this.provider = provider;
        this.port = port;
        this.host = host;
        this.ssl = ssl;
        this.pactfileWriteMode = pactfileWriteMode;
        this.request = new request_1.Request();
        this.baseUrl = (ssl ? "https" : "http") + "://" + host + ":" + port;
        this.pactDetails = {
            consumer: (consumer) ? { name: consumer } : undefined,
            pactfile_write_mode: pactfileWriteMode,
            provider: (provider) ? { name: provider } : undefined,
        };
    }
    /**
     * Adds an interaction
     * @param {Interaction} interaction
     * @returns {Promise}
     */
    MockService.prototype.addInteraction = function (interaction) {
        return this.request.send(request_1.HTTPMethod.POST, this.baseUrl + "/interactions", JSON.stringify(interaction.json()));
    };
    /**
     * Removes all interactions.
     * @returns {Promise}
     */
    MockService.prototype.removeInteractions = function () {
        return this.request.send(request_1.HTTPMethod.DELETE, this.baseUrl + "/interactions");
    };
    /**
     * Verify all interactions.
     * @returns {Promise}
     */
    MockService.prototype.verify = function () {
        return this.request.send(request_1.HTTPMethod.GET, this.baseUrl + "/interactions/verification");
    };
    /**
     * Writes the Pact file.
     * @returns {Promise}
     */
    MockService.prototype.writePact = function () {
        return this.request.send(request_1.HTTPMethod.POST, this.baseUrl + "/pact", JSON.stringify(this.pactDetails));
    };
    return MockService;
}());
exports.MockService = MockService;
//# sourceMappingURL=mockService.js.map