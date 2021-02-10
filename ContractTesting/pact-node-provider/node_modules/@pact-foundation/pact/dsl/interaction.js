"use strict";
/**
 * An Interaction is where you define the state of your interaction with a Provider.
 * @module Interaction
 */
Object.defineProperty(exports, "__esModule", { value: true });
var lodash_1 = require("lodash");
var request_1 = require("../common/request");
var Interaction = /** @class */ (function () {
    function Interaction() {
        this.state = {};
    }
    /**
     * Gives a state the provider should be in for this interaction.
     * @param {string} providerState - The state of the provider.
     * @returns {Interaction} interaction
     */
    Interaction.prototype.given = function (providerState) {
        if (providerState) {
            this.state.providerState = providerState;
        }
        return this;
    };
    /**
     * A free style description of the interaction.
     * @param {string} description - A description of the interaction.
     * @returns {Interaction} interaction
     */
    Interaction.prototype.uponReceiving = function (description) {
        if (lodash_1.isNil(description)) {
            throw new Error("You must provide a description for the interaction.");
        }
        this.state.description = description;
        return this;
    };
    /**
     * The request that represents this interaction triggered by the consumer.
     * @param {Object} requestOpts
     * @param {string} requestOpts.method - The HTTP method
     * @param {string} requestOpts.path - The path of the URL
     * @param {string} requestOpts.query - Any query string in the interaction
     * @param {Object} requestOpts.headers - A key-value pair oject of headers
     * @param {Object} requestOpts.body - The body, in {@link String} format or {@link Object} format
     * @returns {Interaction} interaction
     */
    Interaction.prototype.withRequest = function (requestOpts) {
        if (lodash_1.isNil(requestOpts.method)) {
            throw new Error("You must provide an HTTP method.");
        }
        if (lodash_1.keys(request_1.HTTPMethod).indexOf(requestOpts.method.toString()) < 0) {
            throw new Error("You must provide a valid HTTP method: " + lodash_1.keys(request_1.HTTPMethod).join(", ") + ".");
        }
        if (lodash_1.isNil(requestOpts.path)) {
            throw new Error("You must provide a path.");
        }
        this.state.request = lodash_1.omitBy(requestOpts, lodash_1.isNil);
        return this;
    };
    /**
     * The response expected by the consumer.
     * @param {Object} responseOpts
     * @param {string} responseOpts.status - The HTTP status
     * @param {string} responseOpts.headers
     * @param {Object} responseOpts.body
     */
    Interaction.prototype.willRespondWith = function (responseOpts) {
        if (lodash_1.isNil(responseOpts.status) || responseOpts.status.toString().trim().length === 0) {
            throw new Error("You must provide a status code.");
        }
        this.state.response = lodash_1.omitBy({
            body: responseOpts.body,
            headers: responseOpts.headers || undefined,
            status: responseOpts.status,
        }, lodash_1.isNil);
        return this;
    };
    /**
     * Returns the interaction object created.
     * @returns {Object}
     */
    Interaction.prototype.json = function () {
        if (lodash_1.isNil(this.state.description)) {
            throw new Error("You must provide a description for the Interaction");
        }
        return this.state;
    };
    return Interaction;
}());
exports.Interaction = Interaction;
//# sourceMappingURL=interaction.js.map