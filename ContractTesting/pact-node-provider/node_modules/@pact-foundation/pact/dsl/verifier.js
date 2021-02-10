"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
/**
 * Provider Verifier service
 * @module ProviderVerifier
 */
var pact_node_1 = require("@pact-foundation/pact-node");
var utils_1 = require("../common/utils");
var Verifier = /** @class */ (function () {
    function Verifier() {
    }
    Verifier.prototype.verifyProvider = function (opts) {
        return utils_1.qToPromise(pact_node_1.default.verifyPacts(opts));
    };
    return Verifier;
}());
exports.Verifier = Verifier;
//# sourceMappingURL=verifier.js.map