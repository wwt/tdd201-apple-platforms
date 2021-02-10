"use strict";
var __assign = (this && this.__assign) || Object.assign || function(t) {
    for (var s, i = 1, n = arguments.length; i < n; i++) {
        s = arguments[i];
        for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
            t[p] = s[p];
    }
    return t;
};
function __export(m) {
    for (var p in m) if (!exports.hasOwnProperty(p)) exports[p] = m[p];
}
Object.defineProperty(exports, "__esModule", { value: true });
// tslint:disable:no-console
/**
 * Pact module for Web use.
 * @module Pact Web
 */
var es6_promise_1 = require("es6-promise");
var lodash_1 = require("lodash");
var interaction_1 = require("./dsl/interaction");
var mockService_1 = require("./dsl/mockService");
es6_promise_1.polyfill();
/**
 * Creates a new {@link PactWeb}.
 * @memberof Pact
 * @name create
 * @param {PactOptions} opts
 * @return {@link PactWeb}
 * @static
 */
var PactWeb = /** @class */ (function () {
    function PactWeb(config) {
        var defaults = {
            consumer: "",
            cors: false,
            host: "127.0.0.1",
            pactfileWriteMode: "overwrite",
            port: 1234,
            provider: "",
            spec: 2,
            ssl: false,
        };
        this.opts = __assign({}, defaults, config);
        if (!lodash_1.isEmpty(this.opts.consumer) || !lodash_1.isEmpty(this.opts.provider)) {
            console.warn("Passing in consumer/provider to PactWeb is deprecated,\n        and will be removed in the next major version");
        }
        console.info("Setting up Pact using mock service on port: \"" + this.opts.port + "\"");
        this.mockService = new mockService_1.MockService(this.opts.consumer, this.opts.provider, this.opts.port, this.opts.host, this.opts.ssl, this.opts.pactfileWriteMode);
    }
    /**
     * Add an interaction to the {@link MockService}.
     * @memberof PactProvider
     * @instance
     * @param {Interaction} interactionObj
     * @returns {Promise}
     */
    PactWeb.prototype.addInteraction = function (interactionObj) {
        var interaction = new interaction_1.Interaction();
        if (interactionObj.state) {
            interaction.given(interactionObj.state);
        }
        interaction
            .uponReceiving(interactionObj.uponReceiving)
            .withRequest(interactionObj.withRequest)
            .willRespondWith(interactionObj.willRespondWith);
        return this.mockService.addInteraction(interaction);
    };
    /**
     * Checks with the Mock Service if the expected interactions have been exercised.
     * @memberof PactProvider
     * @instance
     * @returns {Promise}
     */
    PactWeb.prototype.verify = function () {
        var _this = this;
        return this.mockService.verify()
            .then(function () { return _this.mockService.removeInteractions(); })
            .catch(function (e) {
            throw new Error(e);
        });
    };
    /**
     * Writes the Pact and clears any interactions left behind.
     * @memberof PactProvider
     * @instance
     * @returns {Promise}
     */
    PactWeb.prototype.finalize = function () {
        var _this = this;
        return this.mockService.writePact().then(function () { return _this.mockService.removeInteractions(); });
    };
    /**
     * Writes the Pact file but leave interactions in.
     * @memberof PactProvider
     * @instance
     * @returns {Promise}
     */
    PactWeb.prototype.writePact = function () {
        return this.mockService.writePact();
    };
    /**
     * Clear up any interactions in the Provider Mock Server.
     * @memberof PactProvider
     * @instance
     * @returns {Promise}
     */
    PactWeb.prototype.removeInteractions = function () {
        return this.mockService.removeInteractions();
    };
    return PactWeb;
}());
exports.PactWeb = PactWeb;
/**
 * Exposes {@link Matchers}
 * To avoid polluting the root module's namespace, re-export
 * Matchers as its owns module
 * @memberof Pact
 * @static
 */
var Matchers = require("./dsl/matchers");
exports.Matchers = Matchers;
/**
 * Exposes {@link Interaction}
 * @memberof Pact
 * @static
 */
__export(require("./dsl/interaction"));
/**
 * Exposes {@link MockService}
 * @memberof Pact
 * @static
 */
__export(require("./dsl/mockService"));
//# sourceMappingURL=pact-web.js.map